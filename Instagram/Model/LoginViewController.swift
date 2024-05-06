//
//  LoginViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 03/05/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var auth: Auth!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        /*
        //MARK: - automatic log in
        auth.addStateDidChangeListener { auth, user in
            if user != nil{
                self.performSegue(withIdentifier: Constants.segueLogin, sender: nil)
            }else{
                print("Erro")
            }
        }
         */
    }
    
    
    //MARK: - User Log In
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if let email = textFieldEmail.text, let password = textFieldPassword.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error{
                    print("Erro \(error.localizedDescription)")
                    let alertErro = Alert(tittle: "Create your account", message: "You need to create your account first.")
                    self.present(alertErro.getAlert(), animated: true)
                }else{
                    self.performSegue(withIdentifier: Constants.segueLogin, sender: nil)
                    print("Log in done")
                }
            }
            
        }
    }
    
    
    
    
    
    //MARK: - Hiding the keyboard when touch out of him
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
