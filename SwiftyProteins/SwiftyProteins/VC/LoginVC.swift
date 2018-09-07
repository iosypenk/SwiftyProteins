//
//  LoginVC.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit
import LocalAuthentication
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var touchID: UIButton!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginVC.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        toggleAuthUI()
    }
    
    
    //TODO MARK: -Check when touch id appears after return from listVC
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // [START touchID]
         let context: LAContext = LAContext()
         var error: NSError?
        
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            touchID.isHidden = false
        } else {
            touchID.isHidden = true
        }
        // [END touchID]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }    

    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: -Biometrics ID
    
    @IBAction func idAuth(_ sender: Any) {
        
        let context: LAContext = LAContext()
        var error: NSError?

        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            touchID.isHidden = false
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (succes, error) in
                DispatchQueue.main.async {
                    if succes {
                        print("OK")
                        self.performSegue(withIdentifier: "showList", sender: self)
                    } else {
                        if let error = error {
                            print(error)
                        }
                    }
                }
            })
        }
        else {
            showAlertController("Biometric ID is not available")
        }
    }
    
    
    //MARK: -Google ID
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
            touchID.isHidden = true
            self.performSegue(withIdentifier: "showList", sender: self)
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            touchID.isHidden = false
        }
    }
    // [END toggle_auth]
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo["statusText"]!)
            }
        }
    }
    
    //MARK: -Button Actions
    
    @IBAction func didTapDisconnect(_ sender: UIButton) {
        GIDSignIn.sharedInstance().disconnect()
                if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("has keychain")
        } else {
            print("removed")
        }
    }
    
    @IBAction func didTapSignOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
         print("try Sign out")
        toggleAuthUI()
    }
    
    
    
}

