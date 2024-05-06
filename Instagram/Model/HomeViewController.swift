//
//  HomeViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 03/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorageUI

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableViewPosts: UITableView!
    
    
    var auth: Auth!
    var firestore: Firestore!
    var idUser: String!
    
    var posts: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        // recupera o ID do usuario logado
        if let idUser = auth.currentUser?.uid{
            self.idUser = idUser
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recoverPosts()
    }

    
    
    func recoverPosts(){
        //removendo os posts e carregando sempre que a view aparecer
        self.posts.removeAll()
        self.tableViewPosts.reloadData()
        
        //recuperando posts do firebase
        firestore.collection("users").document(idUser).collection("posts").getDocuments { snapshotResult, error in
            if let snapshot = snapshotResult{
                for document in snapshot.documents{
                    let dados = document.data()
                    self.posts.append(dados)
                }
                self.tableViewPosts.reloadData()
            }
        }
    }
    
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifers.cellPost, for: indexPath) as! PostsTableViewCell
        
        let index = indexPath.row
        let posts = self.posts[index]
        
        let description = posts["Description"] as? String
        
        if let url = posts["urlImage"] as? String{
            cell.imagePost.sd_setImage(with: URL(string: url), completed: nil)
        }
        
        
        
        cell.labelPost.text = description
        //cell.imagePost.image = UIImage(named: Constants.images.imageTest)
        
        
        return cell
    }
    
    
}
