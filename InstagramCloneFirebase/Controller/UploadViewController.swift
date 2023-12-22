//
//  UploadViewController.swift
//  InstagramCloneFirebase
//
//  Created by Beste on 18.10.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explanationText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resmi tıklanabilir hale getirmek için
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        tapGesture.delegate = self
        imageView.addGestureRecognizer(tapGesture)
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        //4) -> fotoğrafı yükleme işlemi -> firebase storage -> fotoğraf -> firebase firestore -> tarih & açıklama -> fotoğraf
        //bende hata verdi FirebaseStorage import edilmediği için onu import ettim
        let storage = Storage.storage()
        let storageReferences = storage.reference()
        //biz media kısmını firebase' de oluşturduk ama oluşturmamış olsaydık da bu kod bizim için oluşturucaktı.
        let mediaFolder = storageReferences.child("media")
        
        //imageView'daki görseli kaydedebilmek için görseli önce bir data' ya dönüştürmemiz gerekiyor. Data olarak kaydedebiliyoruz veri tabanına UIImage olarak kaydedemiyoruz
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            //yapabilirsen image' i jpeg data şeklinde al
            
            //burda aldığın fotoğrafı "image.jpg" olarak kaydet diyoruz fakat bu doğru olmaz çünkü yüklenen her fotoğrafı bu şekilde kaydedicek
            //her fotoğrafın adı farklı olmalı -> UUID -> string ver dedik -> dms uzantılı kaydetti bu app için sıkıntı çıkartabilir bu yüzden .jpg şeklinde kaydetmek istiyoruz
            let uuid = UUID().uuidString
            
            let imageReferences = mediaFolder.child("\(uuid).jpg")
            //bu tarz closure' lar için completion olanı kullanıyoruz -> sonunda bir callback fonksiyonu olanı çağırıyoruz çünkü hata fırlatıyor hata olursa.
            imageReferences.putData(data, metadata: nil) { metaData, error in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    

                    imageReferences.downloadURL { url, error in
                        
                        if error == nil {
                            //url' yi al string' e çevir demek
                            let imageUrl = url?.absoluteString
                            
                            //5) -> Firebase Firestore
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReferences : DocumentReference? = nil
                            //postun içinde olucaklar -> tarihi eklemeyi görücez şimdilik date: date yaptık -> FieldValue.simpleTimestamp()
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email, "postComment": self.explanationText.text, "date": FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                            
                            firestoreReferences = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    //fotoğraf seçtikten, açıklama yazdıktan vs sonra geri geldiğinde boş bir şekilde tekrar görmesi için sıfırlıyoruz
                                    self.imageView.image = UIImage(named: "select_image.png")
                                    self.explanationText.text = ""
                                    //tab bar ile çalışıyoruz -> selected index = 0 -> feed -> selected index  = 1 -> upload -> selected index  = 2 -> settings
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    //3) -> fotoğraf seçimi
    @objc func imageViewTapped() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    // did finish picking media with info -> bu fotoğraf seçimi bittikten sonra ne olucak
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
