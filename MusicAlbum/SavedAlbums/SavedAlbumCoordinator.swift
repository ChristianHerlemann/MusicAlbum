//
//  SavedAlbumCoordinator.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol SavedAlbumCoordinatorDelegate: class {
   func openAlbumSearch()
}

class SavedAlbumCoordinator: NavigationCoordinator {
   
   var childCoordinators: [Coordinator] = []
   var navigator: NavigatorType
   var rootViewController: UINavigationController
   
   weak var delegate: SavedAlbumCoordinatorDelegate?
   private let savedAlbumViewController: SavedAlbumViewController
   
   init() {
      let savedAlbumViewController = SavedAlbumViewController.instantiate(resourceFileName: "SavedAlbum")
      self.savedAlbumViewController = savedAlbumViewController
      
      let navigationController = UINavigationController(rootViewController: savedAlbumViewController)
      self.navigator = Navigator(navigationController: navigationController)
      self.rootViewController = navigationController
   }
   
   func start() {
      savedAlbumViewController.delegate = self
   }
}

extension SavedAlbumCoordinator: SavedAlbumViewControllerDelegate {
   
   func openAlbumSearch() {
      delegate?.openAlbumSearch()
   }
   
   func openAlbumDetailView(_ album: Album){
      let coordinator = AlbumDetailsCoordinator(navigator: navigator)
      coordinator.setDisplayAlbum(album)
      pushCoordinator(coordinator, animated: true)
   }
   
   func present(_ contextMenu: UIAlertController) {
      rootViewController.present(contextMenu, animated: true, completion: nil)
   }
}
