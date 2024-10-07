//
//  SceneDelegate.swift
//  Concepts
//
//  Created by Karthik Reddy on 05/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        
        // Set the rootViewController to the tab bar controller
        /// for tab bar view controller
        //        window?.rootViewController = createTabBarController()
        //        let newsViewController = NewsViewController()
        //        window?.rootViewController = ApiViewController()
        // Create a new UIWindow instance and assign it to the window property
        window = UIWindow(windowScene: windowScene)
        //        let searchVC = SearchViewController()
        //        let vc = ClosureViewController()
        //        let newVC = UINavigationController(rootViewController: vc)
        //
        //        window?.rootViewController = newVC
        
        
        // Create instance of the FirstViewController
        let firstVC = FirstViewController()
        
        // Create instance of the SecondViewController
//        let secondVC = SecondViewController()
        
        // Set up a navigation controller to manage both view controllers
        let navigationController = UINavigationController(rootViewController: firstVC)
//        navigationController.viewControllers = [firstVC, secondVC] // Add both view controllers
        
        // Make the navigation controller the root view controller
        window?.rootViewController = navigationController
        
        // Make the window visible
        window?.makeKeyAndVisible()
    }
    
    func createTabBarController() -> UIViewController {
        let tabBarController = UITabBarController()
        
        // properties of tab bar controller
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.backgroundColor = .white
        
        // Create View Controllers for each tab
        let homeViewController = HomeViewController()
        let settingsViewController = SettingsViewController()
        let profileViewController = ProfileViewController()
        
        // Assigning the view controllers to the tab bar
        tabBarController.viewControllers = [
            createNavController(for: homeViewController, title: "Home", imageName: "house"),
            createNavController(for: settingsViewController, title: "Settings", imageName: "gear"),
            createNavController(for: profileViewController, title: "Profile", imageName: "person")
        ]
        
        return tabBarController
    }
    
    func createNavController(for rootViewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName) // System images (SF Symbols)
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

