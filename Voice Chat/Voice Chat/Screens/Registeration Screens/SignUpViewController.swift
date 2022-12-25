//
//  SignUpViewController.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit


// MARK: UNUSED
final class SignUpViewController: UIViewController {
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneCodeTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var signUpBTN: UIButton!
    @IBOutlet var profileImageGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        profileImageGesture.addTarget(self, action: #selector(profileImageClicked))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(profileImageGesture)
    }
    
    private func configureUI() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
    }
    
    
    
    @objc func profileImageClicked() {
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
    }
    
}
