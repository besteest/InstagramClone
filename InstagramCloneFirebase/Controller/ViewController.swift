//
//  ViewController.swift
//  InstagramCloneFirebase
//
//  Created by Beste on 18.10.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //2) Giriş yapma
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            auth.signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
                
            }
            
        } else {
            
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
            
        }
        
    }
    
    //1) Kullanıcı oluşturma
    @IBAction func signUpClicked(_ sender: Any) {
                
        if emailText.text != "" && passwordText.text != "" {
            
            auth.createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                //closure
                if error != nil {
                    
                    //hata verdi ?? olana tıkladık -> default value -> "Error" yazdık
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
                
            }
            
        } else {
            
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
            
        }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

