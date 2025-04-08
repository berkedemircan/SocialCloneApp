//
//  SettingsVC.swift
//  FirebasedApp
//
//  Created by Berke Demircan on 18.04.2025.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toVC", sender: nil)
            
            
        } catch {
            
            print("Error!")
            
            
            
        }
    }
    

}
