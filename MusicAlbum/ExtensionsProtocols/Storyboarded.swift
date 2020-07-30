//
//  Storyboarded.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol Storyboarded
{
    static func instantiate(resourceFileName fname: String) -> Self
}

extension Storyboarded where Self: UIViewController
{
   static func instantiate(resourceFileName fname: String) -> Self
   {
      let fullName = NSStringFromClass(self)
      let className = fullName.components(separatedBy: ".")[1]
      let storyboard = UIStoryboard(name: fname, bundle: nil)
        
      return storyboard.instantiateViewController(withIdentifier: className) as! Self
   }
}
