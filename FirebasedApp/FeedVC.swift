//
//  FeedVC.swift
//  FirebasedApp
//
//  Created by Berke Demircan on 18.04.2025.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedVC: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var userEmailArray = [String]()

    var userCaptionArray = [String]()
    
    var likeArray = [Int]()
    
    var userImageArray = [String]()
    
    var documentIdArray = [String]()
    
    




    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        getDataFromFirestore()
    }
    
    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
       
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                
                print(error?.localizedDescription)
                
                
                
            }
            
            else {
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCaptionArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentID =  document.documentID
                        self.documentIdArray.append(documentID)
                        
                        
                        if let postedBy = document.get("postedBy") as? String {
                            
                            self.userEmailArray.append(postedBy)
                        }
                            
                        if let postComment = document.get("postComment") as? String {
                            
                            
                            self.userCaptionArray.append(postComment)
                        }
                        
                        
                        if let likes = document.get("likes") as? Int {
                            
                            self.likeArray.append(likes)
                        }
                        
                        
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            
                            self.userImageArray.append(imageUrl)
                            
                            
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                    
                }
                
                
                
                
                
            }
            
            
        }
        
        
        
        
                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userNickLabel.text = userEmailArray[indexPath.row]
        
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        cell.captionLabel.text = userCaptionArray[indexPath.row]

        
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        
        cell.documentIdLabel.text = self.documentIdArray[indexPath.row]
        
        
        return cell

    }
    
    
    


}
