//
//  FeedViewController.swift
//  InstagramCloneFirebase
//
//  Created by Beste on 18.10.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        //table view cell içerisindeki objelere ulaşabildiğime göre artık onları set edebilirim.
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        //image' ı bu şekilde yapamıyoruz o yüzden -> SDWebImage kütüphanesini kullanıcaz
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        //beni sabahtan beri uğraştıran o constraint hatası -> image view' a width & height constraint' i ekle
        //bir de programı her çalıştırdığımda 2 tane fotoğraf olmasına rağmen birden çok kez gösteriyor bunun sebebi dizileri hiç temizlemiyor olmamız for loop' un üstüne gidiyoruz.
        
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        return cell
        
    }
    
    //veritabanından feed' e veri çekme işlemi
    func getDataFromFirestore() {
        
        let firestore = Firestore.firestore()

        // by: tarihe göre -> descending: true -> tarihe göre azalarak
        firestore.collection("Posts").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            
            if error != nil {
                
                print(error?.localizedDescription ?? "Error")
                
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    //dizileri temizleme işlemi
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            
                            self.userEmailArray.append(postedBy)
                            
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            
                            self.userCommentArray.append(postComment)
                            
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

}
