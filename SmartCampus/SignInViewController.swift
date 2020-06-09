//
//  SignInViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 10/29/18.
//  Copyright © 2018 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import LocalAuthentication
import SwiftKeychainWrapper

class SignInViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    //    let saveSuccessful: Bool = KeychainWrapper.standard.set("Some String", forKey: "myKey")
    
    var context = LAContext()
    
    
    var myString:NSString = "WRUD";
    var myMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //state = .loggedout
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.performSegue(withIdentifier: "signIntoTabbar", sender: nil)
            } else {
                // No user is signed in.
            }
        }//https://stackoverflow.com/questions/37536499/how-to-maintain-user-session-after-exiting-app-in-firebase
        //        let colorRed: UIColor? = titleLabel.textColor
//        titleLabel.layer.shadowColor = colorRed?.cgColor
//        titleLabel.layer.shadowRadius = 4.0
//        titleLabel.layer.shadowOpacity = 0.9
//        titleLabel.layer.shadowOffset = CGSize.zero
//        titleLabel.layer.masksToBounds = false
       
 titleLabel.setTextWithTypeAnimation(typedText:"WRUD", characterDelay:  100) //less delay is faster
       
        //       signInButton.isEnabled = true
        
        // Do any additional setup after loading the view.
        // return
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "Wrong username or password.",
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Try Again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    var state = AuthenticationState.loggedout {
        
        // Update the UI on a change.
        didSet {
            signInButton.isHighlighted = state == .loggedin  // The button text changes on highlight.
            //            stateView.backgroundColor = state == .loggedin ? .green : .red
            
            // FaceID runs right away on evaluation, so you might want to warn the user.
            //  In this app, show a special Face ID prompt if the user is logged out, but
            //  only if the device supports that kind of authentication.
            //            faceIDLabel.isHidden = (state == .loggedin) || (context.biometryType != .faceID)
        }
    }
    
    @IBAction func UseFaceID(_ sender: UIButton) {
        if state == .loggedin {
            state = .loggedout
            
        } else {
            
            // Get a fresh context for each login. If you use the same context on multiple attempts
            //  (by commenting out the next line), then a previously successful authentication
            //  causes the next policy evaluation to succeed without testing biometry again.
            //  That's usually not what you want.
            context = LAContext()
            
            context.localizedCancelTitle = "Enter Username/Password"
            
            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    
                    if success {
                        
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }
                        let retrievedUsername: String? = KeychainWrapper.standard.string(forKey: "userEmail")
                        let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "userPassword")
                        print("Retreive username was successful: \(String(describing: retrievedUsername))")
                        print("Retreive password was successful: \(String(describing: retrievedPassword))")
                        
                        DispatchQueue.main.async{
                            self.emailTextfield.text = "\(String(describing: retrievedUsername ?? "nil"))"
                            self.passwordTextfield.text = "\(String(describing: retrievedPassword ?? "nil"))"
                            self.signInButton.addTarget(self, action: Selector(("pressed:")), for: .touchUpInside)
                        }
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        
                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                
                // Fall back to a asking for username and password.
                // ...
            }
        }
    }
    @IBAction func singInButtonContr(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty else {
            print("return here")
            return }
        guard let password = passwordTextfield.text, !password.isEmpty else {
            print("return here")
            return
            
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to sign in with email:", err)
                self.presentAlertWithTitle(title: "Warning", message: "The email address does not match the password", options: "Okay") { (option) in
                    print("option: \(option)")
                    switch(option) {
                    case 0:
                        print("option one")
                        break
                    //  return
                    case 1:
                        print("option two")
                        break
                    //return
                    default:
                        print("option two")
                        break
                    }
                }
                
                
                
                return
                
            }
            
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            let savePassword: Bool = KeychainWrapper.standard.set(password, forKey: "userPassword")
            print("Save was successful: \(savePassword)")
            let saveEmail: Bool = KeychainWrapper.standard.set(email, forKey: "userEmail")
            print("Save was successful: \(saveEmail)")
            
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "signIntoTabbar", sender: nil)
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func login(){
        guard let email = emailTextfield.text, !email.isEmpty else { return }
        guard let password = passwordTextfield.text, !password.isEmpty else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            let saveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: "userPassword")
            print("Save was successful: \(saveSuccessful)")
            
            
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "signIntoTabbar", sender: nil)
        })
    }
}

