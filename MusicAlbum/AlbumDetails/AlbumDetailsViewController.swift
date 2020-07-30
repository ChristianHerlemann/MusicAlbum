//
//  AlbumDetailsViewController.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol AlbumDetailsViewControllerDelegate: class {
   
}

class AlbumDetailsViewController: UIViewController, Storyboarded {
   
   @IBOutlet var cover: UIImageView!
   @IBOutlet var albumName: UILabel!
   @IBOutlet var albumArtist: UILabel!
   @IBOutlet var addDeleteBtn: UIButton!
   @IBOutlet var songList: UITableView!
   
   weak var delegate: AlbumDetailsViewControllerDelegate?
   var displayedAlbum: Album?
   let dataStore = DataStore.shared
   private var isSaved = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let displayedAlbum = displayedAlbum, displayedAlbum.tracks?.track.count ?? 0 <= 0 {
         dataStore.getInfo(for: displayedAlbum) { fullAlbumInfo in
            self.displayedAlbum = fullAlbumInfo
            self.reloadData()
         }
      }
      
      
      self.songList.dataSource = self
      
      self.addDeleteBtn.layer.cornerRadius = 8
      self.addDeleteBtn.clipsToBounds = true
      self.cover.layer.cornerRadius = 12
      self.cover.clipsToBounds = true
      self.reloadData()
      
      NotificationCenter.default.addObserver(self, selector: #selector(checkSaved), name: .DatabaseChanged, object: nil)
   }
   
   private func reloadData() {
      
      if let coverURL = displayedAlbum?.cover {
         dataStore.loadImage(url: coverURL){ image in
            self.cover.image = image
         }
      }
      
      self.albumName.text = displayedAlbum?.name
      self.albumArtist.text = displayedAlbum?.artist
      
      if dataStore.checkAlbumStored(displayedAlbum) {
         addDeleteBtn.setTitle("Delete Album", for: .normal)
         addDeleteBtn.backgroundColor = .systemRed
         isSaved = true
      } else {
         addDeleteBtn.setTitle("Add Album", for: .normal)
         addDeleteBtn.backgroundColor = .systemGreen
         isSaved = false
      }
      
      songList.reloadData()
   }
   
   @objc
   private func checkSaved() {
      if dataStore.checkAlbumStored(displayedAlbum) {
         addDeleteBtn.setTitle("Delete Album", for: .normal)
         addDeleteBtn.backgroundColor = .systemRed
         isSaved = true
      } else {
         addDeleteBtn.setTitle("Add Album", for: .normal)
         addDeleteBtn.backgroundColor = .systemGreen
         isSaved = false
      }
   }
   
   @IBAction func addDeleteTapped(_ sender: Any) {
      if isSaved {
         dataStore.deleteStoredAlbum(displayedAlbum)
         self.navigationController?.popViewController(animated: true)
      } else {
         dataStore.saveAlbum(displayedAlbum)
      }
   }
   
}

extension AlbumDetailsViewController: UITableViewDataSource {
   
   var reusableId: String { return "AlbumSongEntry"}
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return displayedAlbum?.tracks?.track.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let songEntry = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath) as? AlbumSongEntry
      
      songEntry?.songNumber.text = "\(indexPath.row)"
      songEntry?.songTitle.text = displayedAlbum?.tracks?.track[indexPath.row].name
      return songEntry!
   }
}

class AlbumSongEntry: UITableViewCell {
   
   @IBOutlet var songNumber: UILabel!
   @IBOutlet var songTitle: UILabel!
}
