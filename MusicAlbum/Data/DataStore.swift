//
//  DataStore.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

class DataStore {
   
   static let shared = DataStore()
   private let defaults = UserDefaults.standard
   private let searchEngine = AlbumSearchManager.shared
   private let database = RealmConnector.shared
   
   private init(){}
}

// MARK: - Onboarding
extension DataStore {
   private var firstStartKey: String { return "FirstAppStart" }
   
   func fetchAppState(isFirstAppStart: @escaping (Bool) -> Void) {
      isFirstAppStart(defaults.string(forKey: firstStartKey) == nil)
   }
   
   func set(isFirstAppStart: Bool) {
      isFirstAppStart ? defaults.removeObject(forKey: firstStartKey) : defaults.set(firstStartKey, forKey: firstStartKey)
   }
}

// MARK: - Local Stored Albums
extension Notification.Name { static let StoredAlbumsChanged = Notification.Name("StoredAlbumsChanged") }
extension DataStore {
   
   func saveAlbum(_ album: Album?) {
      guard let album = album else { return }
      
      searchEngine.getAlbumInfo(name: album.name!, artist: album.artist!, completion: { loadedAblum in
         guard let loadedAlbum = loadedAblum else { return }
         self.database.write(album: loadedAlbum)
      })
      
   }
   
   func loadStoredAlbums() -> [Album] {
      return database.read()
   }
   
   func deleteStoredAlbum(_ album: Album?) {
      guard let album = album else { return }
      
      if let storedAlbum: Album = database.read(id: "\(String(describing: album.name))\(String(describing: album.artist))") {
         database.delete(item: storedAlbum)
      }
   }
   
   func checkAlbumStored(_ album: Album?) -> Bool {
      
      
      let storedAlbum: Album? = database.read(id: "\(String(describing: album?.name))\(String(describing: album?.artist))" )
      
      return storedAlbum != nil
   }
   
   @objc private func onDatabaseChanged() {
      
   }
}

// MARK: - Search Engine Last FM

extension DataStore {
   
   func search(for phrase: String, completion: @escaping ([Album]?) -> Void) {
      searchEngine.search(for: phrase, completion: completion)
   }
   
   func search(for phrase: String, completion: @escaping ([Artist]?) -> Void) {
      searchEngine.search(for: phrase, completion: completion)
   }
   
   func getInfo(for album: Album, completion: @escaping (Album?) -> Void) {
      guard let albumName = album.name, let albumArtist = album.artist else { return }
      
      searchEngine.getAlbumInfo(name: albumName, artist: albumArtist, completion: completion)
   }
   
   func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
      searchEngine.loadImage(url: url, completion: completion)
   }
   
}
