//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Taiki Kanzaki on 2019/04/02.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            print("ユーザー登録出来た！")
            //FirebaseAuthのユーザーIDを代入
            guard let uid = user?.user.uid else {
                return
            }
            
            //successfully authenticated user
            //ユーザーごとにユニークなimageNameを画像につける
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_Images").child("\(imageName).png")
            
            //プロフ画像をストレージにアップロードする
            if let uploadData = self.profileImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    print(metadata)
                    //ストレージにアップロードした画像のURLを表示させる
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        //データベースにユーザーとプロフィール画像のURLを紐づけて格納
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl] as [String : AnyObject]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                        }

                        print(url)
                    })
                    
                })
            
            
            
            
            
            //            ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
            //
            //                if err != nil {
            //                    print("データベース失敗！！")
            //                    print(err)
            //                    return
            //                }
            //
            //                print("Saved user successfully into firebase db!")
            //
            //            })
        }
    }
    }
    
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
//        let values = ["name": name, "email": email, "profileImageUrl": url]
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("データベース失敗！！")
                print(err)
                return
            }
            
            print("Saved user successfully into firebase db!")
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("canceled picker")
        dismiss(animated: true, completion: nil)
        
    }
        
    

    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
}
