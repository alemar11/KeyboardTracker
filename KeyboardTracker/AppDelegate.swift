//
//  AppDelegate.swift
//  KeyboardTracker
//
//  Created by Alessandro Marzoli on 25/01/2019.
//  Copyright © 2019 Alessandro Marzoli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let splitViewController = UISplitViewController()
    let master = UINavigationController(rootViewController: ViewController())
    let detail = UINavigationController(rootViewController: ViewController())

    splitViewController.viewControllers = [master, detail]

    self.window = UIWindow()
    self.window?.rootViewController = splitViewController
    self.window?.makeKeyAndVisible()
    return true
  }

}

