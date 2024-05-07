//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 07/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorageUI

class ProfileViewController: UIViewController  {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    var firestore: Firestore!
    var auth: Auth!
    var idUser: String!
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firestore = Firestore.firestore()
        auth = Auth.auth()
        storage = Storage.storage()
        
        if let id = auth.currentUser?.uid{
            self.idUser = id
        }
        imagePicker.delegate = self
        recoverData()
        
    }
    
    //MARK: - acess the photo library
    @IBAction func btnImage(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    func recoverData(){
        let userRef = self.firestore.collection("users").document(idUser)
        
        userRef.getDocument { snapshot, error in
            if let data = snapshot?.data(){
                let nameUser = data["Name"] as? String
                let emailUser = data["Email"] as? String
                
                self.labelName.text = nameUser
                self.labelEmail.text = emailUser
                
                if let urlImage = data["urlImageProfile"] as? String{
                    self.profileImage.sd_setImage(with: URL(string: urlImage))
                }
            }
        }
    }

}


extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // fazendo a imagem de perfil escolhida aparecer
        let imageRecover = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profileImage.image = imageRecover
        imagePicker.dismiss(animated: true)
        
        
        //as fotos ficarao salva no db como imageProfile
        let imageProfile = storage.reference().child("profile")
        
        if let imageUpload = imageRecover.jpegData(compressionQuality: 0.5){
            if let userLogged = auth.currentUser{
                let idUser = userLogged.uid
                
                let nameImage = "\(idUser).jpg"
                let imageProfileRef = imageProfile.child("imagesProfile").child(nameImage)
                
                //atualizando o firestore com a url da imagem
                imageProfileRef.putData(imageUpload, metadata: nil) { metadata, error in
                    if error == nil{
                        imageProfileRef.downloadURL { url, error in
                            if let urlImage = url?.absoluteString{
                                self.firestore.collection("users").document(idUser).updateData(["urlImageProfile": urlImage])
                            }
                        }
                    }else{
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
}
