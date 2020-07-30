//
//  AlbumDetailsCoordinator.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

class AlbumDetailsCoordinator: NavigationCoordinator {
   var childCoordinators: [Coordinator] = []
   var navigator: NavigatorType
   var rootViewController: UIViewController
   
   private let albumDetailsViewController: AlbumDetailsViewController
   
   init(navigator: NavigatorType) {
      let albumDetailsViewController = AlbumDetailsViewController.instantiate(resourceFileName: "AlbumDetails")
      self.albumDetailsViewController = albumDetailsViewController
      self.navigator = navigator
      self.rootViewController = albumDetailsViewController
   }
   
   func start() {
      albumDetailsViewController.delegate = self
   }
   
   func setDisplayAlbum(_ album: Album) {
      albumDetailsViewController.displayedAlbum = album
   }
   
}

extension AlbumDetailsCoordinator: AlbumDetailsViewControllerDelegate {
  
}
