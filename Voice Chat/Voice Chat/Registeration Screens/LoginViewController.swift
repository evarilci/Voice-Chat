//
//  LoginViewController.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var signUpBTN: UIButton!
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
      
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("email or password is blank")
            return
        }
        
        auth.signIn(withEmail: email,
                    password: password){ result, err in
            
            if err != nil{
                print("Error: \(err!.localizedDescription)")
                return
            } else {
                let tabBarViewController = TabBarViewController()
                self.navigationController?.pushViewController(tabBarViewController, animated: true)
                print("Signed In")
            }
            
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("email or password is blank")
            return
        }
        if email != "" && password != "" {
            auth.createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    print("create user error occured")
                } else {
                    let tabBarViewController = TabBarViewController()
                    self.navigationController?.pushViewController(tabBarViewController, animated: true)
                    print("signed up")
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
}
