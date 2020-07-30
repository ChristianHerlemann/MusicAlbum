//
//  ApprootViewController.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

class AppRootViewController: UIViewController {
   
   func set(childViewController controller: UIViewController) {
      addChild(controller)
      controller.didMove(toParent: self)
      
      let childView = controller.view!
      
      view.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
      childView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      childView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      childView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      childView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
   }
}
