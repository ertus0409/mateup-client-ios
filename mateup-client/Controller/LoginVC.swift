//
//  LoginVC.swift
//  mateup-client
//
//  Created by Guner Babursah on 28/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    //IBOutlets
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    
    //Variables
    let authService = AuthService.instance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailFld.text, email != "" else {
            showAlert(with: "Error", message: "Please enter a valid email address")
            return
        }
        guard let pass = passwordFld.text, pass != "" else {
            showAlert(with: "Error", message: "Please enter a password over 6 six characters")
            return
        }
        
        authService.logInUser(email: email, password: pass) { (Success) in
            if Success {
                print("User has authenticated")
                self.dismissViewController()
            } else {
                print("ERRO logging in")
            }
        }
    }
    
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            self.navigationController?.popViewController(animated: true)
        }
    }

    

}
