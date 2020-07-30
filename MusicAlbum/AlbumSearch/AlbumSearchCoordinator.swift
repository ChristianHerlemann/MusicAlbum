//
//  AlbumSearchCoordinator.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol AlbumSearchCoordinatorDelegate: class {
   
}

class AlbumSearchCoordinator: NavigationCoordinator {
   var childCoordinators: [Coordinator] = []
   var navigator: NavigatorType
   var rootViewController: UINavigationController
   
   weak var delegate: AlbumSearchCoordinatorDelegate?
   
   private let dataStore = DataStore.shared
   private let albumSearchViewController: AlbumSearchViewController
   
   init() {
      let albumSearchViewController = AlbumSearchViewController.instantiate(resourceFileName: "AlbumSearch")
      self.albumSearchViewController = albumSearchViewController
      
      let navigationController = UINavigationController(rootViewController: albumSearchViewController)
      self.navigator = Navigator(navigationController: navigationController)
      self.rootViewController = navigationController
   }
   
   func start() {
      albumSearchViewController.delegate = self
   }
}

extension AlbumSearchCoordinator: AlbumSearchViewControllerDelegate {
   func openDetailView(_ album: Album) {
      let coordinator = AlbumDetailsCoordinator(navigator: navigator)
      coordinator.setDisplayAlbum(album)
      pushCoordinator(coordinator, animated: true)
   }
   
   private func openAlbumDetailView(_ album: Album) {
      let coordinator = AlbumDetailsCoordinator(navigator: navigator)
      coordinator.setDisplayAlbum(album)
      pushCoordinator(coordinator, animated: true)
   }
}
