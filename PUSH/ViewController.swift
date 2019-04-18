//
//  ViewController.swift
//  PUSH
//
//  Created by Taiki Kanzaki on 2019/03/01.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ViewController: UIViewController {

    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var collectionView4: UICollectionView!
    @IBOutlet weak var collectionView5: UICollectionView!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()

    var selectedTID: String?
    
    let YouTubersTIDs = ["-LcUqTRrrUf-SFf_6TWu", "-LcVHbB4NHJQfmwWsSap", "-LcVHbB4NHJQfmwWsSap", "-LcVHbB4NHJQfmwWsSap", "-LcVHbB4NHJQfmwWsSap", "-LcVHbB4NHJQfmwWsSap", "-LcVHbB4NHJQfmwWsSap", "-LcVHbB4NHJQfmwWsSap"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView1.delegate = self
        self.collectionView1.dataSource = self
        self.collectionView2.delegate = self
        self.collectionView2.dataSource = self
        self.collectionView3.delegate = self
        self.collectionView3.dataSource = self
        self.collectionView4.delegate = self
        self.collectionView4.dataSource = self
        self.collectionView5.delegate = self
        self.collectionView5.dataSource = self
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.automaticallyAdjustsScrollViewInsets = false

        
        
        checkIfUserIsLoggedIn()
        
    }
    
    func checkIfUserIsLoggedIn() {
        //ユーザーがログインしていない場合(currentUserのuidがデータベースにない場合)、自動的にLoginControllerにpresentさせる
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //FirebaseAuthからcurrentUserのuidを取得
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                //データベースから名前を取ってきてNavigationBarに表示
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    self.navigationItem.title = dictionary["name"] as? String
//                }
                print(snapshot)
                print("ユーザーID: \(uid)")
            }
        }
    }
    
    @objc func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "goToProfile") {
            let profileVC: ProfileController = (segue.destination as? ProfileController)!
            // SubViewController のselectedImgに選択された画像を設定する
            profileVC.passedTID = selectedTID
        }
    }
    
    

}


//MARK: extention
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(YouTubersTIDs[indexPath.row])
        
        selectedTID = YouTubersTIDs[indexPath.row]
        if selectedTID != nil {
            performSegue(withIdentifier: "goToProfile",sender: nil)

        }
      
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let url1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image-show.png?alt=media&token=af9f43a2-a840-49ea-a489-5848dd1acc23")
//        let url2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        let url3 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        let url4 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        let url5 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        let url6 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        let url7 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        let url8 = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/%E3%82%BF%E3%83%AC%E3%83%B3%E3%83%88%2Fsample-image.jpg?alt=media&token=7f02da4e-9c6e-45fe-af2c-c5a087d5cb7c")
//        
//        let profileURLs: [URL] = [url1!, url2!, url3!, url4!, url5!, url6!, url7!, url8!]
        
        if collectionView == self.collectionView1 {
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
            let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
            let reference = Database.database().reference().child("talents").child("category").child("YouTuber")
            let tPath = reference.child(YouTubersTIDs[indexPath.row]).child("tfile")
            tPath.observe(.value) { (url) in
                let imageURL = url.value as! String
                
                let imageURL2 = URL(string: imageURL)
                
                //キャッシュをとる
                if let imageFromCache = imageCache.object(forKey: imageURL2 as AnyObject) as? UIImage {
                    imageView1.image = imageFromCache
                    return
                }

                URLSession.shared.dataTask(with: imageURL2!) { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        //キャッシュをとる
                        let imageToCache = UIImage(data: data!)
                        imageCache.setObject(imageToCache!, forKey: imageURL2 as AnyObject)
                        imageView1.image = imageToCache
                    }
                    }.resume()
            }
            
            
            
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
//
//            //以下カスタマイズ
//            let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
//
//            let imageURL = profileURLs[indexPath.row]
//
//                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
//                    if error != nil {
//                        print(error)
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        imageView1.image = UIImage(data: data!)
//                    }
//                    }.resume()
            
            
            //ここまで
            
//            let tIds = ["-LcUqTRrrUf-SFf_6TWu", "-LcVHbB4NHJQfmwWsSap"]
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
//            let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
//
//            let reference = Database.database().reference().child("talents").child("category").child("YouTuber")
//            for tId in tIds {
//                print(tId)
//                let ref = reference.child(tId).child("tfile")
//                ref.observe(.value) { (url) in
//                    let imageURL = url.value as! String
//                    //URLを配列で取り出したい
//
//                    let imageURL2 = URL(string: imageURL)
//
//
//                    URLSession.shared.dataTask(with: imageURL2!) { (data, response, error) in
//                        if error != nil {
//                            print(error)
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            imageView1.image = UIImage(data: data!)
//                        }
//                        }.resume()
//                }
            
//            }
            //ここまで
            return cell1
            
        }else if collectionView == self.collectionView2 {
            print("タグは2です")
            let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath)
            
            return cell2
        }else if collectionView == self.collectionView3 {
            print("タグは3です")
            let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath)
            
            
            return cell3
        }else if collectionView == self.collectionView4 {
            print("タグは4です")
            let cell4 = collectionView4.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell4", for: indexPath)
            
            
            return cell4
        }else if collectionView == self.collectionView5 {
            print("タグは5です")
            let cell5 = collectionView5.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell5", for: indexPath)
            
            
            return cell5
        }
        
        return UICollectionViewCell()
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//                if collectionView == self.collectionView1 {
//                    let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
//                    var index = 0
//
//                            let tIds = ["-LcUqTRrrUf-SFf_6TWu", "-LcVHbB4NHJQfmwWsSap"]
//                            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
//                            let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
//
//                            let reference = Database.database().reference().child("talents").child("category").child("YouTuber")
//                            for tId in tIds {
//                                print(tId)
//                                let ref = reference.child(tId).child("tfile")
//                                ref.observe(.value) { (url) in
//                                    let imageURL = url.value as! String
//                                    //URLを配列で取り出したい
//
//                                    let imageURL2 = URL(string: imageURL)
//
//
//                                    URLSession.shared.dataTask(with: imageURL2!) { (data, response, error) in
//                                        if error != nil {
//                                            print(error)
//                                            return
//                                        }
//                                        DispatchQueue.main.async {
//                                            imageView1.image = UIImage(data: data!)
//                                        }
//                                        }.resume()
//                                }
//
//                    }
//
//                    return cell1
//
//                }else if collectionView == self.collectionView2 {
//                    print("タグは2です")
//                    let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath)
//
//                    return cell2
//                }else if collectionView == self.collectionView3 {
//                    print("タグは3です")
//                    let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath)
//
//
//                    return cell3
//                }else if collectionView == self.collectionView4 {
//                    print("タグは4です")
//                    let cell4 = collectionView4.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell4", for: indexPath)
//
//
//                    return cell4
//                }else if collectionView == self.collectionView5 {
//                    print("タグは5です")
//                    let cell5 = collectionView5.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell5", for: indexPath)
//
//
//                    return cell5
//                }
//
//                return UICollectionViewCell()
//            }
//
        //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        //        let storageRef = storage.reference(forURL: "gs://push-bc760.appspot.com")
        //
        //        if collectionView == self.collectionView1 {
        //            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        //        let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
        //        let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
        //        imageView1.sd_setImage(with: reference)
        //
        //        return cell1
        //
        //        }else if collectionView == self.collectionView2 {
        //            print("タグは2です")
        //        let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath)
        //        let imageView2 = cell2.contentView.viewWithTag(1) as! UIImageView
        //        let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
        //        imageView2.sd_setImage(with: reference)
        //
        //        return cell2
        //        }else if collectionView == self.collectionView3 {
        //            print("タグは3です")
        //            let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath)
        //            let imageView3 = cell3.contentView.viewWithTag(1) as! UIImageView
        //            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
        //            imageView3.sd_setImage(with: reference)
        //
        //            return cell3
        //        }else if collectionView == self.collectionView4 {
        //            print("タグは4です")
        //            let cell4 = collectionView4.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell4", for: indexPath)
        //            let imageView4 = cell4.contentView.viewWithTag(1) as! UIImageView
        //            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
        //            imageView4.sd_setImage(with: reference)
        //
        //            return cell4
        //        }else if collectionView == self.collectionView5 {
        //            print("タグは5です")
        //            let cell5 = collectionView5.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell5", for: indexPath)
        //            let imageView5 = cell5.contentView.viewWithTag(1) as! UIImageView
        //            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
        //            imageView5.sd_setImage(with: reference)
        //
        //            return cell5
        //        }
        //
        //        return UICollectionViewCell()
        //    }
        
        

//        var index = 0
//
//        let tIds = ["-LcUqTRrrUf-SFf_6TWu", "-LcVHbB4NHJQfmwWsSap"]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Ceeel", for: indexPath)
//        let imageView1 = cell.contentView.viewWithTag(1) as! UIImageView
//
//        let reference = Database.database().reference().child("talents").child("YouTuber")
//        for tId in tIds {
//            let ref = reference.child(tId).child("tfile")
//            ref.observe(.value) { (url) in
//                let imageURL = url.value as! String
//                let imageURL2 = URL(string: imageURL)
//                imageView1.sd_setImage(with: imageURL2)
//
//            }
//        }


//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let storageRef = storage.reference(forURL: "gs://push-bc760.appspot.com")
//
//        if collectionView == self.collectionView1 {
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
//            let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView1.sd_setImage(with: reference)
//
//            return cell1
//
//        }else if collectionView == self.collectionView2 {
//            print("タグは2です")
//            let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath)
//            let imageView2 = cell2.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView2.sd_setImage(with: reference)
//
//            return cell2
//        }else if collectionView == self.collectionView3 {
//            print("タグは3です")
//            let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath)
//            let imageView3 = cell3.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView3.sd_setImage(with: reference)
//
//            return cell3
//        }else if collectionView == self.collectionView4 {
//            print("タグは4です")
//            let cell4 = collectionView4.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell4", for: indexPath)
//            let imageView4 = cell4.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView4.sd_setImage(with: reference)
//
//            return cell4
//        }else if collectionView == self.collectionView5 {
//            print("タグは5です")
//            let cell5 = collectionView5.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell5", for: indexPath)
//            let imageView5 = cell5.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView5.sd_setImage(with: reference)
//
//            return cell5
//        }
//
//        return UICollectionViewCell()
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let storageRef = storage.reference(forURL: "gs://push-bc760.appspot.com")
//
//        if collectionView == self.collectionView1 {
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
//        let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
//        let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//        imageView1.sd_setImage(with: reference)
//
//        return cell1
//
//        }else if collectionView == self.collectionView2 {
//            print("タグは2です")
//        let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath)
//        let imageView2 = cell2.contentView.viewWithTag(1) as! UIImageView
//        let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//        imageView2.sd_setImage(with: reference)
//
//        return cell2
//        }else if collectionView == self.collectionView3 {
//            print("タグは3です")
//            let cell3 = collectionView3.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath)
//            let imageView3 = cell3.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView3.sd_setImage(with: reference)
//
//            return cell3
//        }else if collectionView == self.collectionView4 {
//            print("タグは4です")
//            let cell4 = collectionView4.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell4", for: indexPath)
//            let imageView4 = cell4.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView4.sd_setImage(with: reference)
//
//            return cell4
//        }else if collectionView == self.collectionView5 {
//            print("タグは5です")
//            let cell5 = collectionView5.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell5", for: indexPath)
//            let imageView5 = cell5.contentView.viewWithTag(1) as! UIImageView
//            let reference = storageRef.child("/タレント/女優/model\(indexPath.row).jpg")
//            imageView5.sd_setImage(with: reference)
//
//            return cell5
//        }
//
//        return UICollectionViewCell()
//    }
    
    
}

