//
//  StorageViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 08/10/24.
//

import UIKit
import Foundation

struct UserProfile: Codable {
    var name: String
    var age: Int
    var email: String
}

class StorageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userDefaultsExample()
//        documentStorageExample()
        
        let userProfile = UserProfile(name: "John Doe", age: 28, email: "john.doe@example.com")

        // Save the profile to file
        saveUserProfile(userProfile)

        // Load the profile from file
        if let loadedProfile = loadUserProfile() {
            print("User Profile: \(loadedProfile.name), \(loadedProfile.age), \(loadedProfile.email)")
        }

    }
    
    func userDefaultsExample() {
        print("setting value - ")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            print("fetching value after 5 seconds", isLoggedIn)
        }
    }
    
    func documentStorageExample() {
        // Getting path to the documents directory
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("myFile.txt")
            
            // Writing to a file
            try? "Hello, World!".write(to: filePath, atomically: true, encoding: .utf8)
            
            // Reading from a file
            if let content = try? String(contentsOf: filePath) {
                print(content)  // Output: Hello, World!
            }
        }
    }
    
    func saveUserProfile(_ profile: UserProfile) {
        // Getting path to the documents directory
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("userProfile.json")
            
            do {
                // Encoding the profile to JSON data
                let jsonData = try JSONEncoder().encode(profile)
                
                // Writing JSON data to file
                try jsonData.write(to: filePath, options: .atomic)
                print("User profile saved at: \(filePath)")
            } catch {
                print("Failed to save user profile: \(error)")
            }
        }
    }
    
    func loadUserProfile() -> UserProfile? {
        // Getting path to the documents directory
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("userProfile.json")
            
            do {
                // Reading data from the file
                let data = try Data(contentsOf: filePath)
                
                // Decoding the JSON data into a `UserProfile` object
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                return userProfile
            } catch {
                print("Failed to load user profile: \(error)")
            }
        }
        return nil
    }
}
