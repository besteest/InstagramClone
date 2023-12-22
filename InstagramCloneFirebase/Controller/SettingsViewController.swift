//
//  SettingsViewController.swift
//  InstagramCloneFirebase
//
//  Created by Beste on 18.10.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        //yeni segue oluşturduk -> show -> amacı settings kısmından log out butonuna basınca bizi ilk sayfaya atması.
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error")
        }
        
    }
    
}
