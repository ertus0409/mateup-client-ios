//
//  CreateUserVC.swift
//  mateup-client
//
//  Created by Guner Babursah on 29/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit

class CreateUserVC: UIViewController {
    
    @IBOutlet weak var rePasswordFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    
    let authService = AuthService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let email = emailFld.text, email != "" else {
            showAlert(with: "Error", message: "Please enter a valid email address")
            return
        }
        guard let pass = passwordFld.text, pass != "", pass == rePasswordFld.text else {
            showAlert(with: "Error", message: "Please enter valid and matching passwords")
            return
        }
        
        authService.registerUser(email: email, password: pass) { (Success) in
            if Success {
                self.dismissViewController()
            } else {
                self.showAlert(with: "Error", message: "An error occured trying to regiter. Please check your internet connection and retry.")
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            let main = self.navigationController?.viewControllers[0] as! MainVC
            self.navigationController?.popToViewController(main, animated: true)
        }
    }
}
