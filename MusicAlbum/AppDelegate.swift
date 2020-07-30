//
//  AppDelegate.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-24.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var appCoordinator: AppCoordinator?
   var window: UIWindow?
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      let window = UIWindow(frame: UIScreen.main.bounds)
      self.window = window
      appCoordinator = AppCoordinator(window: window)
      appCoordinator?.start()
      
      return true
   }
}

