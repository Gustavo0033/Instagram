//
//  GaleryCollectionViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 06/05/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorageUI

class GaleryCollectionViewController: UICollectionViewController {
    
    var firestore: Firestore!
    var idUserSelected: String!
    var posts: [Dictionary<String, Any>] = []
    var users: Dictionary<String, Any>!

    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        
        if let id = users["id"] as? String{
            idUserSelected = id
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recoverPosts()
    }
    

    //MARK: - Recovering posts from the user
    func recoverPosts(){
        self.posts.removeAll()
        self.collectionView.reloadData()
        
        //recovering posts from the Firebase
        firestore.collection("users").document(idUserSelected).collection("posts").getDocuments { snapshotResult, error in
            if let snapshot = snapshotResult{
                for document in snapshot.documents{
                    let dados = document.data()
                    self.posts.append(dados)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - set in the number of lines on the TableView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.posts.count
    }

    
    //MARK: - setting the image and label on TableView and showing.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.identifers.galeryCollection, for: indexPath) as! GaleryCollectionViewCell
        
        let index = indexPath.row
        let posts = self.posts[index]
        
        let description = posts["Description"] as? String
        
        if let url = posts["urlImage"] as? String{
            cell.image.sd_setImage(with: URL(string: url), completed: nil)
        }
        
        cell.label.text = description

    
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
