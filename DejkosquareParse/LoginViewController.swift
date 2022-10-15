//
//  ViewController.swift
//  DejkosquareParse
//
//  Created by Furkan Cemal Çalışkan on 18.09.2022.
//

import UIKit
import Parse


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    //Segue
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        } else {
            
            makeAlert(title: "Error", message: "Username/Password?")
            
        }
        
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
   
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
                
        } else {
            
            makeAlert(title: "Error", message: "Username/Password?")
            
        }
            
            
        
        
    }
    
    
    
    func makeAlert(title: String, message: String) {
        
        let error = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        error.addAction(okButton)
        self.present(error, animated: true, completion: nil)
        
    }
    

}

