//
//  AppDelegate.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "1010996599859-mg1pfsga06f1oofr8l5g7u8vn51mjous.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    // [END openurl]
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName ?? "fullname")"])
            // [END_EXCLUDE]
            print(fullName ?? "fullName")
        }
    }
    // [END signin_handler]

    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {

        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
    func applicationDidEnterBackground(_ application: UIApplication) {

//        guard let nav = window?.rootViewController as? MainNavigationController else { return }

        print("DidEnterBackground")
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
        
        
        let vc = UIApplication.shared.keyWindow?.rootViewController
        
        
        if let nav = vc as? UINavigationController {
            let str: String = String(describing: nav.visibleViewController)
            print("сработало    " + str)
            
            if str.contains("Optional(<SwiftyProteins.ProteinListVC:") {
                print("ALARM!!")
                nav.popViewController(animated: true)
            }
            
            if str.contains("Optional(<SwiftyProteins.ProteinVC:") {
                print("2 POP!!")
                let first = nav.viewControllers[0]
                nav.popToViewController(first, animated: true)
            }
        }
        
     
//        nav.present(nav.viewControllers[0] , animated: true, completion: nil)
        
//          let vc = UIApplication.shared.keyWindow?.rootViewController
        
          /*if let _ = vc as? UINavigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            let navigationController = vc
//            navigationController?.showDetailViewController(destinationViewController, sender: Any?.self)
            vc?.present(destinationViewController, animated: true, completion: nil)
        }*/
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        let vc = UIApplication.shared.keyWindow?.rootViewController
//
//
//        if let nav = vc as? UINavigationController {
//            let str: String = String(describing: nav.visibleViewController)
//            print("сработало    " + str)
//
//            if str.contains("Optional(<SwiftyProteins.ProteinListVC:") {
//                print("ALARM!!")
//                nav.popViewController(animated: true)
//            }
//
//            if str.contains("Optional(<SwiftyProteins.ProteinVC:") {
//                print("2 POP!!")
//                let first = nav.viewControllers[0]
//                nav.popToViewController(first, animated: true)
//            }
//        }
//
//        if let presented = vc?.presentedViewController {
//            let str: String = String(describing: presented)
//            print(str)
//        }
    
    }
  
    
}

