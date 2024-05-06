//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 03/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    
    var db: Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }
    
    
    //MARK: - User Sign Up
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        if let email = textFieldEmail.text, let password = textFieldPass.text, let name = textFieldName.text{
            Auth.auth().createUser(withEmail: email, password: password) { dataUsers, error in
                if let error = error{
                    print("Error\(error.localizedDescription)")
                }else{
                    //saving datas on Firebase
                    if let idUser = dataUsers?.user.uid{
                        
                        self.db.collection("users").document(idUser).setData(["Name": name, "Email": email, "id": idUser])
                    }

                   // self.performSegue(withIdentifier: Constants.segueSignUp, sender: nil)
                    print("Criado com sucesso!")
                }
            }
            
        }
        
    }
    
    //MARK: - Hiding the keyboard when touch out of him
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
