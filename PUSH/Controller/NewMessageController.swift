//
//  NewMessageController.swift
//  gameofchats
//
//  Created by Taiki Kanzaki on 2019/04/01.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }

    func fetchUser() {
        //users以下の回想のデータを取ってきて一覧表示
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User()
                //エラーが起きたため置き換え
                //user.setValuesForKeys(dictionaryOfUsers)
                user.name = dictionary["name"] as! String
                user.email = dictionary["email"] as! String
                user.profileImageUrl = dictionary["profileImageUrl"] as! String
                
                self.users.append(user)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let use a hack for now, we actually need to dequeue our cells for memoryefficiency
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
//        cell.imageView?.image = UIImage(named: "push_logo.png")
//        cell.imageView?.contentMode = .scaleAspectFit
        
        if let profileImageUrl = user.profileImageUrl{
            print("実行されたんご")
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                }
            }.resume()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "push_logo.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        //iOS 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
