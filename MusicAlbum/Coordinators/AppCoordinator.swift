//
//  AppCoordinator.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

class AppCoordinator: PresentationCoordinator {
   
   var childCoordinators: [Coordinator] = []
   var rootViewController = AppRootViewController()
   
   private let dataService = DataStore.shared
   
   init(window: UIWindow) {
      window.rootViewController = rootViewController
      window.makeKeyAndVisible()
   }
   
   func start() {
      dataService.fetchAppState { [weak self] isFirstAppStart in
         self?.route(isFirstAppStart: isFirstAppStart)
      }
   }
}

// MARK: - Routing

private extension AppCoordinator {
   
   func route(isFirstAppStart: Bool) {
      
      let savedAlbumCoordinator = SavedAlbumCoordinator()
      addChildCoordinator(savedAlbumCoordinator)
      savedAlbumCoordinator.delegate = self
      savedAlbumCoordinator.start()
      rootViewController.set(childViewController: savedAlbumCoordinator.rootViewController)
      
      if isFirstAppStart {
         let onboardingCoordinator = OnboardingCoordinator()
         onboardingCoordinator.delegate = self
//         onboardingCoordinator._rootViewController.modalPresentationStyle = .fullScreen
         presentCoordinator(onboardingCoordinator, animated: true)
      } else {
         let savedAlbumCoordinator = SavedAlbumCoordinator()
         addChildCoordinator(savedAlbumCoordinator)
         savedAlbumCoordinator.delegate = self
         savedAlbumCoordinator.start()
         rootViewController.set(childViewController: savedAlbumCoordinator.rootViewController)
      }
   }
}

// MARK: - Onboarding Coordinator Delegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
   
   func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
      let isFirstAppStart = false
      dataService.set(isFirstAppStart: isFirstAppStart)
      route(isFirstAppStart: isFirstAppStart)
      
      dismissCoordinator(coordinator, animated: true)
   }
}

// MARK: - Saved Album Coordinator Delegate
extension AppCoordinator: SavedAlbumCoordinatorDelegate {
   func openAlbumSearch() {
      openSearch()
   }
}

// MARK: - Album SearchCoordinator Delegate
extension AppCoordinator: AlbumSearchCoordinatorDelegate {
   
   func openSearch() {
      let searchAlbumCoordinator = AlbumSearchCoordinator()
      searchAlbumCoordinator.delegate = self
      presentCoordinator(searchAlbumCoordinator, animated: true)
   }
}
