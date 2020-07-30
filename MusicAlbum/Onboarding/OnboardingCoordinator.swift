//
//  OnboardingCoordinator.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: class {
   func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: NavigationCoordinator {
   
   weak var delegate: OnboardingCoordinatorDelegate?
   
   var childCoordinators: [Coordinator] = []
   var navigator: NavigatorType
   var rootViewController: UINavigationController
   
   private let onboardingViewController: OnboardingViewController
   
   init() {
      let initialViewController = OnboardingViewController.instantiate(resourceFileName: "Onboarding")
      self.onboardingViewController = initialViewController
      
      let navigationController = UINavigationController(rootViewController: initialViewController)
      navigationController.navigationBar.isHidden = true
      self.navigator = Navigator(navigationController: navigationController)
      self.rootViewController = navigationController
   }
   
   func start() {
      onboardingViewController.delegate = self
   }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
   func onboardingDidFinish(_ controller: OnboardingViewController) {
      delegate?.onboardingCoordinatorDidFinish(self)
   }
}
