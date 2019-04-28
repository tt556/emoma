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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var selectedCategory: String?

    var selectedTID: String?
    
    let refreshControl = UIRefreshControl()
    
    //ホーム画面に優先表示したいタレントのTID
    let YouTubersTIDs = ["-LcUqTRrrUf-SFf_6TWu", "-LcVHbB4NHJQfmwWsSap", "-LcxlTSxXG7YbWy_FQen", "-LcxlTSxXG7YbWy_FQen", "-LcxlTSxXG7YbWy_FQen", "-LcxlTSxXG7YbWy_FQen", "-LcxlTSxXG7YbWy_FQen", "-LcxlTSxXG7YbWy_FQen"]
    let talentsTIDs = ["-LcxqM_5g7T50nBTuoAY","-LcxqUK4yVE0Fzl7m6XY","-LcxqeiBDbRDe8FV92Yp","-LcxqeiBDbRDe8FV92Yp","-LcxqeiBDbRDe8FV92Yp","-LcxqeiBDbRDe8FV92Yp","-LcxqeiBDbRDe8FV92Yp","-LcxqeiBDbRDe8FV92Yp"]
    let liversTIDs = ["-Lcxqmk8bu59F2eIaAqT","-Lcxqy86sbt6SPRXghgf","-Lcxr3KQ_VNGlWC0pekM","-Lcxr3KQ_VNGlWC0pekM","-Lcxr3KQ_VNGlWC0pekM","-Lcxr3KQ_VNGlWC0pekM","-Lcxr3KQ_VNGlWC0pekM","-Lcxr3KQ_VNGlWC0pekM"]
    
    
    
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
        scrollView.contentInsetAdjustmentBehavior = .never
        
        searchBar.layer.shadowColor = UIColor.lightGray.cgColor
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.masksToBounds = false
        

        //refreshControl
        scrollView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        checkIfUserIsLoggedIn()
        
    }
    
    @objc func refresh() {
       
        DispatchQueue.main.async {
            self.scrollView.reloadInputViews()
            self.feedbackGenerator.impactOccurred()
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    private let feedbackGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    
    func checkIfUserIsLoggedIn() {
        //ユーザーがログインしていない場合(currentUserのuidがデータベースにない場合)、自動的にLoginControllerにpresentさせる
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //FirebaseAuthからcurrentUserのuidを取得
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
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
            profileVC.passedCategory = selectedCategory
        }
    }
    
    

}


//MARK: extention
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView1 {
            selectedCategory = "YouTuber"
            selectedTID = YouTubersTIDs[indexPath.row]

        } else if collectionView == self.collectionView2 {
            selectedCategory = "タレント"
            selectedTID = talentsTIDs[indexPath.row]

        }else if collectionView == self.collectionView3{
            selectedCategory = "ライバー"
            selectedTID = liversTIDs[indexPath.row]
        }
        
        if selectedCategory != nil && selectedTID != nil {
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

        if collectionView == self.collectionView1 {
            
            var selectedCategory = "YouTuber"
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
            let imageView1 = cell1.contentView.viewWithTag(1) as! UIImageView
            
            let reference = Database.database().reference().child("talents").child("category").child(selectedCategory)
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

            return cell1
            
        }else if collectionView == self.collectionView2 {
            var selectedCategory = "タレント"
//
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath)
            let imageView2 = cell2.contentView.viewWithTag(1) as! UIImageView
            let reference = Database.database().reference().child("talents").child("category").child(selectedCategory)
            let tPath = reference.child(talentsTIDs[indexPath.row]).child("tfile")
            tPath.observe(.value) { (url) in
                let imageURL = url.value as! String
                let imageURL2 = URL(string: imageURL)

                //キャッシュをとる
                if let imageFromCache = imageCache.object(forKey: imageURL2 as AnyObject) as? UIImage {
                    imageView2.image = imageFromCache
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
                        imageView2.image = imageToCache
                    }
                    }.resume()
            }
            
            return cell2
        }else if collectionView == self.collectionView3 {
            var selectedCategory = "ライバー"

            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath)
            let imageView3 = cell3.contentView.viewWithTag(1) as! UIImageView
            let reference = Database.database().reference().child("talents").child("category").child(selectedCategory)
            let tPath = reference.child(liversTIDs[indexPath.row]).child("tfile")
            tPath.observe(.value) { (url) in
                let imageURL = url.value as! String
                let imageURL2 = URL(string: imageURL)

                //キャッシュをとる
                if let imageFromCache = imageCache.object(forKey: imageURL2 as AnyObject) as? UIImage {
                    imageView3.image = imageFromCache
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
                        imageView3.image = imageToCache
                    }
                    }.resume()
            }
            
            return cell3
            
        }else if collectionView == self.collectionView4 {
            let cell4 = collectionView4.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell4", for: indexPath)
            return cell4
        }else if collectionView == self.collectionView5 {
            let cell5 = collectionView5.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell5", for: indexPath)
            return cell5
        }
        
        return UICollectionViewCell()
    }
    
    

}

