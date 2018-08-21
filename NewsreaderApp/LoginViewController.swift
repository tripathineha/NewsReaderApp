//
//  LoginViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 30/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard var emailId = emailTextField.text,
            let password = passwordTextField.text else {
                createAlert(title: "Invalid Inputs", message: "Some fields are empty!", hasCancelAction: false)
                return
        }
        
        emailId = emailId.lowercased()
        let isValidUser = DataManager.sharedInstance.login(emailId : emailId, password : password)
        
        if isValidUser {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            navigationController?.pushViewController(viewController, animated: true)
            
        } else {
            createAlert(title: "Invalid Inputs", message: "Either Username or Password is wrong!", hasCancelAction: false)
            return
        }
    }
}
