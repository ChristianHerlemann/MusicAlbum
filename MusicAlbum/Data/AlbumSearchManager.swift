//
//  AlbumSearchManager.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-26.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//


import Alamofire
import AlamofireImage

class AlbumSearchManager {
   
   static let shared = AlbumSearchManager()
   
   let lastFMDetails: [String: String] = [
      "APIkey": "7cdf32b83f156e21972a8b50b70468e9",
      "BaseURL": "https://ws.audioscrobbler.com/2.0/",
      "SharedSecret": "4f5530aede3daf2cd3accbfdad9d8ea8",
      "Username": "chrisherlemann"]
   
   private init() {}
   
   func search(for phrase: String, completion: @escaping ([Album]?) -> Void) {
      guard let baseURL = lastFMDetails["BaseURL"] else { return }
      
      let searchParameters = [
         "method": "album.search",
         "album": phrase,
         "api_key": lastFMDetails["APIkey"],
         "format": "json"
      ]
      
      AF.request(baseURL, parameters: searchParameters).response { response in
         
         guard let data = response.data else { return }
         do {
            let decoder = JSONDecoder()
            let searchResult = try decoder.decode(AlbumSearchResults.self, from: data)
            completion(searchResult.results.albumMatches.album)
         } catch let error {
            print(error)
            completion(nil)
         }
      }
   }
   
   func search(for phrase: String, completion: @escaping ([Artist]?) -> Void) {
      guard let baseURL = lastFMDetails["BaseURL"] else { return }
      
      let searchParameters = [
         "method": "artist.search",
         "artist": phrase,
         "api_key": lastFMDetails["APIkey"],
         "format": "json"
      ]
      
      AF.request(baseURL, parameters: searchParameters).response { response in
         
         guard let data = response.data else { return }
         do {
            let decoder = JSONDecoder()
            let searchResult = try decoder.decode(ArtistSearchResults.self, from: data)
            completion(searchResult.results.artistMatches.artist)
         } catch let error {
            print(error)
            completion(nil)
         }
      }
   }
   
   func getAlbumInfo(name albumName: String, artist: String, completion: @escaping (Album?) -> Void) {
      
      guard let baseURL = lastFMDetails["BaseURL"] else { return }
      
      let albumParameters = [
         "method": "album.getInfo",
         "album": albumName,
         "artist": artist,
         "api_key": lastFMDetails["APIkey"],
         "format": "json"
      ]
      
      AF.request(baseURL, parameters: albumParameters).response { response in
         guard let data = response.data else { return }
         do {
            let decoder = JSONDecoder()
            let albumInfo = try decoder.decode(AlbumInfo.self, from: data)
            
            completion(albumInfo.album)
         } catch let error {
            print(error)
            completion(nil)
         }
      }
   }
   
   func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
      AF.request(url).responseImage { response in
         if case .success(let image) = response.result {
            completion(image)
         }
      }
   }
}
