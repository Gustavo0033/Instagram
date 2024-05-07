//
//  UsersViewController.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 06/05/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UsersViewController: UIViewController, UISearchBarDelegate {
    
    var auth: Auth!
    var firestore: Firestore!
    var idUser: String!
    
    var users: [Dictionary<String, Any>] = []
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        firestore = Firestore.firestore()
        self.searchBar.delegate = self
        
        // recupera o ID do usuario logado
        if let idUser = auth.currentUser?.uid{
            self.idUser = idUser
        }
    }
    
    //MARK: - when view appear, will bring the user from firebase
    override func viewDidAppear(_ animated: Bool) {
        recoverUsers()
    }
    
    //MARK: - search the user
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            if searchText != ""{
                searchUsers(text: searchText)
                searchBar.endEditing(true)
            }
        }
    }

    
    
    //MARK: - bring the users if the textfield from the searchBar is empty

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            recoverUsers()
        }
    }
    
    //MARK: - bring the user, searched by the name
    func searchUsers(text: String){
        let filter: [Dictionary<String, Any>] = self.users
        self.users.removeAll()
        
        for item in filter{
            if let name = item["Name"] as? String{
                if name.lowercased().contains(text.lowercased()){
                    self.users.append(item)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //MARK: - assim que o usuario clicar na tableView, ele vai desmarcar onde foi clicado

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        
        //quando clicar em cima do usuario, vai trazer os dados do mesmo
        let index = indexPath.row
        let user = self.users[index]
        
        self.performSegue(withIdentifier: Constants.identifers.segueGalery, sender: user)
        
    }
    
    //MARK: - envinado as informacoes do usuario para a galeriaCollecionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == Constants.identifers.segueGalery{
            let destinyView = segue.destination as! GaleryCollectionViewController
            
            destinyView.users = sender as? Dictionary
            
        }
        
    }
    //MARK: - recovering users data from firebase and updating tableView
    func recoverUsers(){
        self.users.removeAll()
        self.tableView.reloadData()
        
        firestore.collection("users").getDocuments { snapshotResult, error in
            if let snapshot = snapshotResult{
                for document in snapshot.documents{
                    let dados = document.data()
                    self.users.append(dados)
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    
    //MARK: - recovering the users from firebase
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifers.userCell, for: indexPath)
        
        let index = indexPath.row
        let user = self.users[index]
        
        let name = user["Name"] as? String
        let email = user["Email"] as? String
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = email
        return cell
    }
}
