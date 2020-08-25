//
//  AlbumSearchViewController.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol AlbumSearchViewControllerDelegate: class {
   func openDetailView(_ album: Album)
}

enum SearchType: Int {
   case AlbumSearch = 0
   case ArtistSearch = 1
}

class AlbumSearchViewController: UIViewController, Storyboarded {
   
   @IBOutlet var searchPhrase: UITextField!
   @IBOutlet var albumOrArtist: UISegmentedControl!
   @IBOutlet var searchResultTable: UITableView!
   @IBOutlet var nothingFoundMessage: UILabel!
   let dataStore = DataStore.shared
   var searchResult: [Searchable]?
   weak var delegate: AlbumSearchViewControllerDelegate?
   
   var searchType: SearchType? {
      return SearchType(rawValue: albumOrArtist.selectedSegmentIndex)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "Search Album Database"
      searchPhrase.becomeFirstResponder()
      searchPhrase.returnKeyType = .search
      searchPhrase.delegate = self
      searchResultTable.delegate = self
      searchResultTable.dataSource = self
      
      NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: .DatabaseChanged, object: nil)
   }
   
   @objc func reloadTable(){
      search()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      if let index = self.searchResultTable.indexPathForSelectedRow{
         self.searchResultTable.deselectRow(at: index, animated: true)
      }
   }
   
   @IBAction func searchTypeChanged(_ sender: UISegmentedControl) {
      self.search()
   }
   
   @IBAction func search(_ sender: UITextField) {
      self.search()
   }
   
   private func search()
   {
      switch searchType {
      case .AlbumSearch:
         searchForAlbum(searchPhrase.text)
      case .ArtistSearch:
         searchForArtist(searchPhrase.text)
      default:
         break
      }
   }
   
   func searchForAlbum(_ albumName: String?) {
      self.nothingFoundMessage.isHidden = true
      
      guard let albumName = albumName, albumName.count > 0 else {
         self.searchResultTable.isHidden = true
         return
      }
      
      dataStore.search(for: albumName) { (searchResult: [Album]?) in
         
         guard let searchResult = searchResult, searchResult.count > 0 else {
            
            self.searchResultTable.isHidden = true
            self.nothingFoundMessage.isHidden = false
            return
         }
         
         self.searchResult = searchResult
         self.searchResultTable.reloadData()
         self.searchResultTable.isHidden = false
         
      }
   }
   
   func searchForArtist(_ artistName: String?) {
      self.nothingFoundMessage.isHidden = true
      
      guard let artistName = artistName, artistName.count > 0 else {
         self.searchResultTable.isHidden = true
         return
      }
      
      dataStore.search(for: artistName) { (searchResult: [Artist]?) in
         
         guard let searchResult = searchResult, searchResult.count > 0 else {
            
            self.searchResultTable.isHidden = true
            self.nothingFoundMessage.isHidden = false
            return
         }
         
         self.searchResult = searchResult
         self.searchResultTable.reloadData()
         self.searchResultTable.isHidden = false
         
      }
   }
}

extension AlbumSearchViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let album = searchResult?[indexPath.row] as? Album else { return }
      delegate?.openDetailView(album)
   }
}

extension AlbumSearchViewController: UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResult?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if let album = searchResult?[indexPath.row] as? Album {
         return createCell(tableView, cellForRowAt: indexPath, album)
      }
      
      if let artist = searchResult?[indexPath.row] as? Artist {
         return createCell(tableView, cellForRowAt: indexPath, artist)
      }
      
      return UITableViewCell()
   }
   
   private func createCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ album: Album?) -> UITableViewCell {
      let albumSearchPreview = tableView.dequeueReusableCell(withIdentifier: "AlbumSearchPreview", for: indexPath) as? AlbumSearchPreview
      
      albumSearchPreview?.delegate = self
      albumSearchPreview?.album = album
      albumSearchPreview?.albumName.text = album?.name
      albumSearchPreview?.albumArtist.text = album?.artist
      albumSearchPreview?.checkStored()
      
      return albumSearchPreview!
   }
   
   private func createCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ artist: Artist?) -> UITableViewCell {
      let artistSearchPreview = tableView.dequeueReusableCell(withIdentifier: "ArtistSearchPreview", for: indexPath) as? ArtistSearchPreview
      
      artistSearchPreview?.artistName.text = artist?.name
      
      return artistSearchPreview!
   }
}

extension AlbumSearchViewController: UITextFieldDelegate {
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
      searchPhrase.resignFirstResponder()
      return false
   }
}

extension AlbumSearchViewController: AlbumSearchPreviewDelegate{
   func isAlbumSaved(_ album: Album?) -> Bool {
      return dataStore.checkAlbumStored(album)
   }
   
   func saveDeleteAlbum(_ album: Album?) {
      
      if isAlbumSaved(album)
      {
         dataStore.deleteStoredAlbum(album)
      } else {
         dataStore.saveAlbum(album)
      }
   }
}

protocol AlbumSearchPreviewDelegate: class {
   func isAlbumSaved(_ album: Album?) -> Bool
   func saveDeleteAlbum(_ album: Album?)
}

class AlbumSearchPreview: UITableViewCell {
   
   @IBOutlet var albumName: UILabel!
   @IBOutlet var albumArtist: UILabel!
   @IBOutlet var addDeleteBtn: UIButton!
   weak var delegate: AlbumSearchPreviewDelegate?
   weak var album: Album?
   private var isSaved: Bool?
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   func checkStored(){
      if let isStored = delegate?.isAlbumSaved(album) {
         addDeleteBtn.imageView?.image = UIImage(named: isStored ? "delete" : "add")
      }
   }
   
   @IBAction func addDeleteAlbum(_ sender: Any) {
      delegate?.saveDeleteAlbum(album)
   }
}

class ArtistSearchPreview: UITableViewCell {
   @IBOutlet var artistName: UILabel!
}
