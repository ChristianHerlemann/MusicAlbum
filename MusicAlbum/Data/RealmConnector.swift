//
//  RealmConnector.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-27.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import Foundation
import RealmSwift

extension Notification.Name { static let DatabaseChanged = Notification.Name("DatabaseChanged") }
class RealmConnector {
   
   static var shared = RealmConnector()
   private let database = try! Realm()
   private init() {}
   
   func write(album:Album){
      
      try! database.write {
         database.add(album)
      }
      
      //According to Realm-Docu write should be synchonous but I have some kind of race condition ?!
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         NotificationCenter.default.post(name: .DatabaseChanged, object: nil)
      }
   }
   
   func read<T: Object>() -> [T] {
      
      let searchResultSet = database.objects(T.self)
      
      guard searchResultSet.count > 0 else { return [] }
      
      var result: [T] = []
      
      for index in [0 ... searchResultSet.count-1] {
         result.append(contentsOf: searchResultSet[index])
      }
      
      return result
   }
   
   func read<T: Object>(id: String) -> T? {
      return database.object(ofType: T.self, forPrimaryKey: id)
   }
   
   func delete(item: Object) {
      try! database.write {
         database.delete(item)
      }
      
      //According to Realm-Docu write should be synchonous but I have some kind of race condition ?!
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         NotificationCenter.default.post(name: .DatabaseChanged, object: nil)
      }
      
   }
   
   
}
