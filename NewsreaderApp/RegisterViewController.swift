//
//  RegisterViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

// MARK: - Validation methods
extension RegisterViewController{
    
    @IBAction func onRegisterButtonTapped(_ sender: UIButton) {
        
        guard var emailId = emailTextField.text,
            let password = passwordTextField.text,
            let repassword = rePasswordTextField.text,
            let username = usernameTextField.text
            else {
                createErrorAlert(title: "Invalid Inputs", message: "Some fields are empty!", hasCancelAction: false)
                return
        }
        
        guard password == repassword else {
            createErrorAlert(title: "Password", message: "Passwords do not match!", hasCancelAction: false)
            return
        }
        
        guard isEmailValid(value: emailId) else {
            createErrorAlert(title: "Email Id", message: "Email id is not valid!", hasCancelAction: false)
            return
        }
        
        guard isPasswordValid(password: password) else {
            createErrorAlert(title: "Password", message: "Password not valid!", hasCancelAction: false)
            return
        }
        
        emailId = emailId.lowercased()
        let isEmailPresent = DataManager.sharedInstance.checkUser(emailId: emailId)
        guard isEmailPresent else {
            createErrorAlert(title: "Email Id", message: "Email id is not valid!", hasCancelAction: false)
            return
        }
        
        let valueDictionary = [ UserEntity.email.rawValue:emailId,
                                UserEntity.name.rawValue:username,
                                UserEntity.password.rawValue:password
                                ]
        
        DataManager.sharedInstance.registerUser(valueDictionary: valueDictionary)
        navigationController?.popViewController(animated: true)
       
    }
    
    func isEmailValid(value:String?) -> Bool{
        let regularExpression = "^[A-Z0-9a-z_.]+@[A-Za-z]+\\.[A-Za-z]{2,3}$"
        if value != nil{
            return value!.range(of: regularExpression, options: .regularExpression, range: nil, locale: nil) != nil
        }
        return false
    }
    
    func isPasswordValid(password:String?) -> Bool{
        if let password = password{
            let regularExpression = "^[^\\s]{8,40}$"
            let isMatch = password.range(of: regularExpression, options: .regularExpression, range: nil, locale: nil) != nil
            return isMatch
        }
        return false
    }
    
}

// MARK: - Custom methods
extension RegisterViewController {
    private func createErrorAlert(title: String?, message: String?, hasCancelAction: Bool)  {
        createAlert(title: title, message: message, hasCancelAction: hasCancelAction)
        passwordTextField.text = ""
        rePasswordTextField.text = ""
        return
    }
}
