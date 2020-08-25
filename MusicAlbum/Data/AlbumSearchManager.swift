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
   
   private init() {}
   
   func search(for phrase: String, completion: @escaping ([Album]?) -> Void) {
      
      AF.request(Router.searchAlbum(albumName: phrase)).responseDecodable(of: AlbumSearchResults.self) { response in
         
         switch response.result {
         case .failure(let error):
            print(error)
         case .success(let data):
            completion(data.results.albumMatches.album)
         }
      }
   }
   
   func search(for phrase: String, completion: @escaping ([Artist]?) -> Void) {
      
      AF.request(Router.searchArtist(artistName: phrase)).responseDecodable(of: ArtistSearchResults.self) { response in
         
         switch response.result {
         case .failure(let error):
            print(error)
         case .success(let data):
            completion(data.results.artistMatches.artist)
         }
      }
   }
   
   func getAlbumInfo(name albumName: String, artist: String, completion: @escaping (Album?) -> Void) {
      
      AF.request(Router.albumInfo(albumName: albumName, artistName: artist)).responseDecodable(of: AlbumInfo.self) { response in
         
         switch response.result {
         case .failure(let error):
            print(error)
         case .success(let data):
            completion(data.album)
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
