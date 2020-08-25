//
//  AlbumSearchRouter.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-08-24.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
   case searchAlbum(albumName: String)
   case searchArtist(artistName: String)
   case albumInfo(albumName: String, artistName: String)
   
   var baseURL: URL {
      return URL(string: "https://ws.audioscrobbler.com/2.0")!
   }
   
   var apiKey: String {
      return "7cdf32b83f156e21972a8b50b70468e9"
   }
   
   var method: HTTPMethod {
      return .get
   }
   
   var parameters: [String: String]? {
      
      var headers = [
         "api_key": apiKey,
         "format": "json"
      ]
      
      switch self {
      case .searchAlbum(let albumName):
         headers["album"] = albumName
         headers["method"] = "album.search"
      case .searchArtist(let artistName):
         headers["artist"] = artistName
         headers["method"] = "artist.search"
      case .albumInfo(let albumName, let artistName):
         headers["artist"] = artistName
         headers["album"] = albumName
         headers["method"] = "album.getInfo"
      }
      return headers
   }
   func asURLRequest() throws -> URLRequest {
      
      var request = URLRequest(url: baseURL)
      request.method = method
      request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)

      return request
   }
}




enum method {
   
}
