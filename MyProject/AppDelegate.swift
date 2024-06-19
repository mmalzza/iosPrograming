//
//  AppDelegate.swift
//  MyProject
//
//  Created by 김마리아 on 6/17/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseFirestore
import FirebaseStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Google Maps API 키 설정
        GMSServices.provideAPIKey("AIzaSyAUjFOO3b2JNaZ4M8hQP0Ke_xtbzMgK-W8")
        GMSPlacesClient.provideAPIKey("AIzaSyAUjFOO3b2JNaZ4M8hQP0Ke_xtbzMgK-W8")
        // Override point for customization after application launch.
        
        // firebase 연결
        //FirebaseApp.configure()
        
        // GoogleService-Info-2.plist 파일 경로 지정
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info-2", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            print("Failed to load GoogleService-Info-2.plist")
        }
        
        // firestore에 저장
        Firestore.firestore().collection("test").document("name").setData(["name": "Maria Kim"])
        
        Thread.sleep(forTimeInterval: 2.0)
                                                                           
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}


