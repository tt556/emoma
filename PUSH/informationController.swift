//
//  informationController.swift
//  PUSH
//
//  Created by Taiki Kanzaki on 2019/04/08.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase

class informationController: UIViewController {
    @IBOutlet weak var inputForVideoContentTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var forWhoSegmentControll: UISegmentedControl!
    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var toTextField1: UITextField!
    var users = [User]()
    var passedTID: String? = nil
    let publishableKey = "pk_test_QJEarN1JjibVSItD1ehS0zac00W80CFyt4"
    let stripeCustomer = StripeCustomer()

    
    let defaultStore = Firestore.firestore()
    
    
    let view1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "D3D3D3", alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topBoarder: UIView = {
        let boarder = UIView()
        boarder.backgroundColor = UIColor.lightGray
        boarder.frame.size.height = 1
        boarder.translatesAutoresizingMaskIntoConstraints = false
        return boarder
    }()
    
    let orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "95D2E1", alpha: 1)
        button.setTitle("¥3000で予約する！", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func onClick() {
        
        let user = User()
//        sendMail(text: inputForVideoContentTextView.text!, email: user.email!, userName: user.name!)
        let orderController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "orderController")

        inputOrderText(TID: passedTID!)
        writeCustomerDataToFirestore(amount: 2000, currency: "JPY")
        self.show(orderController, sender: self)
    }
    
    func setupView1() {
        view1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view1.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setUpTopBoarder() {
        topBoarder.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
        topBoarder.topAnchor.constraint(equalTo: view1.topAnchor).isActive = true
        topBoarder.leftAnchor.constraint(equalTo: view1.leftAnchor).isActive = true
        topBoarder.rightAnchor.constraint(equalTo: view1.rightAnchor).isActive = true
        
    }

    func setUpOrderButton() {
        orderButton.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
        orderButton.topAnchor.constraint(equalTo: view1.topAnchor, constant: 15).isActive = true
        orderButton.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -15).isActive = true
        orderButton.leftAnchor.constraint(equalTo: view1.leftAnchor, constant: 15).isActive = true
        orderButton.rightAnchor.constraint(equalTo: view1.rightAnchor, constant: -15).isActive = true
    }
    
//    let storageRef = Storage.storage().reference().child("profile_Images").child("\(imageName).png")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(passedTID)
        
        navigationItem.title = "予約する"
        //profileImageViewの設定
        
        //inputForVideoContentTextViewの設定
        inputForVideoContentTextView.layer.borderColor = UIColor(hex: "f6f6f6").cgColor
        inputForVideoContentTextView.layer.borderWidth = 1.0
        inputForVideoContentTextView.layer.cornerRadius = 8
        
        view.addSubview(view1)
        view1.addSubview(topBoarder)
        view1.addSubview(orderButton)
        setupView1()
        setUpTopBoarder()
        setUpOrderButton()
        
        orderView.isHidden = true
        
        fetchUserProfileImage()
        
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchUserProfileImage() {
        let ref: DatabaseReference = Database.database().reference()
        let userRef: DatabaseReference = ref.child("users")
        let uid: String = Auth.auth().currentUser!.uid
        
        if uid != nil {
            let profileImageRef: DatabaseReference = userRef.child(uid).child("profileImageUrl")
            profileImageRef.observe(.value, with: { url in
                let stringurl = url.value as! String
                let imageUrl = URL(string: stringurl)
                URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data!)
                    }
                    }.resume()
                }
            )
        
    }
        
    }
    
    func fetchUser() {
        //users以下の階層のデータを取ってきて一覧表示
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User()
                //エラーが起きたため置き換え
                //user.setValuesForKeys(dictionaryOfUsers)
                user.name = dictionary["name"] as! String
                user.email = dictionary["email"] as! String
                user.profileImageUrl = dictionary["profileImageUrl"] as! String
                
                self.users.append(user)
                print(snapshot)
                print("これは今のユーザーのemailです\(user.email)")
                
                if let profileImageUrl = user.profileImageUrl{
                    let url = URL(string: profileImageUrl)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data!)
                        }
                        }.resume()
                }
                
                
                print(user.name, user.email)
                
                //                for dictionary in dictionaryOfUsers {
                //                    let user = User()
                //                    user.setValuesForKeys(dictionary)
                //                    print(user.name, user.email)
                //
                //                }
            }
            
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        if forWhoSegmentControll.selectedSegmentIndex == 0 {
            orderView.isHidden = true
        } else {
            orderView.isHidden = false
        }
        
    }
    
    
}


