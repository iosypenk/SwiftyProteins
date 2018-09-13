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
    @IBOutlet weak var welcomeMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginVC.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        toggleAuthUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        welcomeMessage.isHidden = true
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        GIDSignIn.sharedInstance().disconnect()
        
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
            touchID.isHidden = true
            
            if let myAppDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let name = myAppDelegate.name {
                    //welcomeMessage.isHidden = false //uncomment this for test google auth
                    welcomeMessage.text = "Welcome, \(name) !"
                }
            }
            self.performSegue(withIdentifier: "showList", sender: self)
        } else {
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
    
}

