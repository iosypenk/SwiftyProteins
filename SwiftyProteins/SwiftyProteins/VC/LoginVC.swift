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
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var touchID: UIButton!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginVC.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        toggleAuthUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    @IBAction func idAuth(_ sender: Any) {
        
        let context: LAContext = LAContext()
        var error: NSError?

        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (succes, error) in
                if succes {
                    print("OK")
                } else {
                    if let error = error {
                        print(error)
                    }
                }
            })
        }
        else {
            showAlertController("Touch ID not available")
        }
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
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
    
    @IBAction func didTapDisconnect(_ sender: UIButton) {
        GIDSignIn.sharedInstance().disconnect()
        print("try Disconnect")
    }
    
    @IBAction func didTapSignOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
         print("try Sign out")
        toggleAuthUI()
    }
    
    
}

