//
//  UploadVC.swift
//  FirebasedApp
//
//  Created by Berke Demircan on 18.04.2025.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class UploadVC: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var UploadImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UploadImage.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        UploadImage.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController , animated : true , completion : nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        UploadImage.image = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true , completion : nil)
    }
    

    
    
    func makeAlert(titleInput:String , messageInput :String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func uploadButton(_ sender: Any) {
        
        
        let storage = Storage.storage()
        
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = UploadImage.image?.jpegData(compressionQuality :0.5) {
            
            let uuid = UUID().uuidString
            
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data , metadata :nil) { (metadata,error)   in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                    
                } else {
                    
                    
                    imageReference.downloadURL { (url,error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            //DATABASE
                            
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl! , "postedBy" : Auth.auth().currentUser!.email! , "postComment": self.comment.text! , "date" : FieldValue.serverTimestamp() , "likes" : 0 ] as [String  : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput:"Error!" , messageInput: error?.localizedDescription ?? "Error")
                                    
                                    
                                } else {
                                    
                                    self.UploadImage.image = UIImage(named: "select.png")
                                    
                                    self.comment.text = ""
                                    
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                }
                
            }
        }
    }
    

}
