//
//  SearchResult.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-26.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import Foundation
import RealmSwift

protocol Searchable {}

struct AlbumSearchResults: Decodable {
   let results: Results
}

struct Results: Decodable {
   let albumMatches: AlbumMatches
   
   enum CodingKeys: String, CodingKey {
      case albumMatches = "albummatches"
   }
}

struct AlbumMatches: Decodable {
   let album: [Album]
}

struct AlbumInfo: Decodable {
   let album: Album
}

class Album: Object, Codable, Searchable {
   
   @objc dynamic var ID: String?
   @objc dynamic var name: String?
   var image = List<Image>()
   var cover: String? {
      return image.last?.url
   }
   @objc dynamic var artist: String?
   @objc dynamic var tracks: Tracks?
   
   private enum CodingKeys: String, CodingKey {
      case name, image, artist, tracks
   }
   
   required convenience init(from decoder: Decoder) throws {
      self.init()
      let container = try decoder.container(keyedBy: CodingKeys.self)
      name = try container.decode(String?.self, forKey: .name)
      let imagesArray = try container.decode([Image].self, forKey: .image)
      image.append(objectsIn: imagesArray)
      artist = try container.decode(String?.self, forKey: .artist)
      tracks = try? container.decode(Tracks?.self, forKey: .tracks)
      ID = "\(String(describing: name))\(String(describing: artist))"
   }
   
   override static func primaryKey() -> String? {
     return "ID"
   }
}

class Image: Object, Codable {
   private enum CodingKeys: String, CodingKey { case  url = "#text" }
   
   @objc dynamic var url : String?
   
}

class Tracks: Object, Codable {
   private enum CodingKeys: String, CodingKey { case  track }
   
   var track = List<Track>()
   
   required convenience init(from decoder: Decoder) throws {
      self.init()
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let tracksArray = try container.decode([Track].self, forKey: .track)
      track.append(objectsIn: tracksArray)
   }
}

class Track: Object, Codable {
   @objc dynamic var name: String?
}

