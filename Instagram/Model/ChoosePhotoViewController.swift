//
//  ChoosePhotoViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 03/05/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorageUI
import FirebaseAuth


class ChoosePhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var postComment: UITextField!
    
    var imagePicker = UIImagePickerController()
    var firestore: Firestore!
    var storage: Storage!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        firestore = Firestore.firestore()
        storage = Storage.storage()
        auth = Auth.auth()
        
    }
    
    //MARK: - acessing the photoLibrary from the user
    @IBAction func btnChooseImg(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageSelected.image = imagePicked // make the image appear on the imageView
        
        imagePicker.dismiss(animated: true)
        
    }
    
    @IBAction func savePost(_ sender: UIButton) {
        //MARK: - select the image and saving on firebase
        

            
            
            // saving image on firebase and saving the description
            let images = storage.reference().child("images")
            let chooseImages = self.imageSelected.image
            
            if let imageUploaded = chooseImages?.jpegData(compressionQuality: 0.5){
                
                let identifier = UUID().uuidString
                
                let imageProfileRef = images.child("posts").child("\(identifier).jpg")
                imageProfileRef.putData(imageUploaded, metadata: nil) {
                    (metadata, error) in
                    if error == nil{
                        
                        imageProfileRef.downloadURL { url, error in
                            if let urlImage = url?.absoluteString{
                                if let description = self.postComment.text{
                                    if let userLoged = self.auth.currentUser{
                                        let idUser  = userLoged.uid
                                        self.firestore.collection("users").document(idUser).collection("posts").addDocument(data: ["Description": description, "urlImage": urlImage]) { error in
                                            if error == nil{
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                        print("Sucess")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    }
