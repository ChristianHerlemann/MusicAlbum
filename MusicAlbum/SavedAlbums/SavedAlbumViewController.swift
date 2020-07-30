//
//  SavedAlbumViewController.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol SavedAlbumViewControllerDelegate: class {
   func openAlbumSearch()
   func openAlbumDetailView(_ album: Album)
   func present(_ contextMenu: UIAlertController)
}

class SavedAlbumViewController: UIViewController, Storyboarded {
   
   weak var delegate: SavedAlbumViewControllerDelegate?
   private let dataStore = DataStore.shared
   private var storedAblums: [Album]{
      return dataStore.loadStoredAlbums()
   }
   @IBOutlet var albumCollection: UICollectionView!
   
   override func viewDidLoad() {
      self.title = "Saved Album Artwork"
      let button = UIButton(type: .custom)
      button.setImage(UIImage(named: "search"), for: .normal)
      button.addTarget(self, action:#selector(openSearch), for: .touchDown)
      
      if #available(iOS 13.0, *) {
         button.tintColor = .systemFill
      }
      
      let barButton = UIBarButtonItem(customView: button)
      self.navigationItem.rightBarButtonItems = [barButton]
      
      albumCollection.dataSource = self
      albumCollection.delegate = self
      
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.minimumInteritemSpacing = 0
      flowLayout.minimumLineSpacing = 0
      self.albumCollection.collectionViewLayout = flowLayout
      updateLayout(for: self.view.bounds.size)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      albumCollection.reloadData()
      NotificationCenter.default.addObserver(self, selector: #selector(onDatabaseChanged), name: .DatabaseChanged, object: nil)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      NotificationCenter.default.removeObserver(self, name: .DatabaseChanged, object: nil)
   }
   
   @objc private func onDatabaseChanged() {
      self.albumCollection.reloadData()
   }
   
   private func updateLayout(for size: CGSize) {
      if let flowLayout = albumCollection.collectionViewLayout as? UICollectionViewFlowLayout {
         let width = size.width / 2
         let count = Int(width) / 180
         let itemWidth = width / CGFloat(count)
         flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 50)
         flowLayout.invalidateLayout()
      }
   }
   
   @objc
   func openSearch() {
      delegate?.openAlbumSearch()
   }
}

extension SavedAlbumViewController: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
      delegate?.openAlbumDetailView(storedAblums[indexPath.row])
   }
}

extension SavedAlbumViewController: UICollectionViewDataSource {
   
   private var reusableId: String { return "AlbumPreview" }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      dataStore.loadStoredAlbums().count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let albumPreview = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath) as? AlbumPreview
      
      if let coverURL = storedAblums[indexPath.row].image.last?.url {
         dataStore.loadImage(url: coverURL, completion: { loadedCover in
            guard let loadedCover = loadedCover else { return }
            
            albumPreview?.albumCover.image = loadedCover
         })
      }
      
      albumPreview?.album = storedAblums[indexPath.row]
      albumPreview?.albumName.text = storedAblums[indexPath.row].name
      albumPreview?.albumArtist.text = storedAblums[indexPath.row].artist
      albumPreview?.delegate = self
      
      return albumPreview!
   }
}

extension SavedAlbumViewController: AlbumPreviewDelegate {
   
   func longPress(_ album: Album) {
      let alertActionCell = UIAlertController(title: "Album Action", message: "Choose an action for the selected album", preferredStyle: .actionSheet)
      
      let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
         
         self.dataStore.deleteStoredAlbum(album)
      })

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { acion in
         print("Cancel actionsheet")
      })
      
      alertActionCell.addAction(deleteAction)
      alertActionCell.addAction(cancelAction)
      delegate?.present(alertActionCell)
      
   }
}
