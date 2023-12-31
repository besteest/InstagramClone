//
//  FeedCell.swift
//  InstagramCloneFirebase
//
//  Created by Beste on 19.10.2023.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    //tableview içerisinde oluşturduğumuz cell için açtık
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    var documentIDArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestore = Firestore.firestore()
        
        //like butonuna tıklandığında mevcut like + 1 olsun istiyoruz
        if let likeCount = Int(likeLabel.text!) {
            
            let likeStore = ["likes": likeCount + 1] as [String: Any]
            
            //setData -> merge
            firestore.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)

        }
        
    }
    
}
