//
//  Artist.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-29.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import Foundation
import RealmSwift

struct ArtistSearchResults: Decodable {
   let results: ArtistResults
}

struct ArtistResults: Decodable {
   let artistMatches: ArtistMatches
   
   enum CodingKeys: String, CodingKey {
      case artistMatches = "artistmatches"
   }
}

struct ArtistMatches: Decodable {
   let artist: [Artist]
}

class Artist: Object, Codable, Searchable {
   @objc dynamic var name: String
}
