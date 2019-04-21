//
//  ProfileController.swift
//  PUSH
//
//  Created by Taiki Kanzaki on 2019/03/20.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit
import WebKit

class ProfileController: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameCategoryLabel: UILabel!
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var profileDetailLabel: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var labelForLatestVideos: UILabel!
    
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var videoButton1: UIButton!
    
    var selectedImage: UIImage?
    var passedCategory: String?
    var passedTID: String?
    
    let reference = Database.database().reference()
    
    let videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    
    let gradationLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let startColor = UIColor(hex:"00f1e6", alpha: 0.7).cgColor
        let endColor = UIColor(hex: "D638FF", alpha: 0.7).cgColor
        
        layer.colors = [startColor, endColor]
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("これは受け渡されたcategoryです！：\(passedCategory)")

        print("これは受け渡されたTIDです！：\(passedTID)")
        fetchProfileImage()
        
        //View2にグラデーションを適用
        gradationLayer.frame = view2.bounds
        view2.layer.addSublayer(gradationLayer)
        
        
        scrollView.delegate = self
        
        //自作下部TabBar
        let view1 = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 80, width: view.frame.size.width, height: 80))
        view1.frame.size.width = view.frame.size.width
        view1.backgroundColor = UIColor(hex: "D3D3D3", alpha: 0.5)
//        view.addSubview(view1)
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view1.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        
        
        
        
        //Blur処理
        //Blurエフェクトを作成
        let blurEffect = UIBlurEffect(style: .light)
    
        //Blurエフェクトからエフェクトビューを生成
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        //view1のサイズに合わせる
        visualEffectView.frame = view1.bounds
        
        //view1にBlurエフェクトビューを追加する
        view1.addSubview(visualEffectView)
        //作成したViewに上線を追加
        view1.layer.addSublayer(topBorder)

        
        let priceLabel = UILabel(frame: CGRect(x:20, y:view1.frame.size.height / 5, width:150, height:30))
        priceLabel.text = "3000円"
        priceLabel.textColor = UIColor(hex: "FC437B", alpha: 1)
        
        let howManyDaysToSendLabel = UILabel(frame: CGRect(x:20, y:view1.frame.size.height / 2, width:150, height:30))
        howManyDaysToSendLabel.text = "通常二日でお届け"
        howManyDaysToSendLabel.textAlignment = .center
        howManyDaysToSendLabel.font = UIFont.systemFont(ofSize: 12)
        howManyDaysToSendLabel.textColor = UIColor(hex: "8F8F8F", alpha: 1)
        
        
        
        
        let attrText = NSMutableAttributedString(string: priceLabel.text!)
        //フォントサイズ、太字にする文字位置を設定
        attrText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 30), range: NSMakeRange(0, 5))
        
        //装飾したことをlabelに設定
        priceLabel.attributedText = attrText
        
        var purchaseButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = UIColor(hex: "95D2E1", alpha: 1)
            button.setTitle("¥3000で購入する！", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
            
            return button
        }()
        
        view1.addSubview(purchaseButton)

        purchaseButton.centerYAnchor.constraint(equalTo: view1.centerYAnchor).isActive = true
        purchaseButton.rightAnchor.constraint(equalTo: view1.rightAnchor, constant: -12).isActive = true
        purchaseButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true


        
        view1.addSubview(priceLabel)
        view1.addSubview(howManyDaysToSendLabel)
        
        howManyDaysToSendLabel.centerYAnchor.constraint(equalTo: purchaseButton.centerYAnchor).isActive = true

        view.addSubview(view1)
        view.addSubview(videoImageView)

        
        
        
        //profileImage設定
        profileImage.layer.cornerRadius = 50
        
        //NavigationBar設定
        navigationController?.setNavigationBarHidden(false, animated: true)
        let nameRef = reference.child("talents").child("category").child(passedCategory!).child(passedTID!).child("tname")
        nameRef.observeSingleEvent(of: .value) { (snapshot) in
            let tname: String = snapshot.value as! String
            self.navigationItem.title = tname
            self.nameCategoryLabel.text = tname
        }
        
        let detailLabelRef = reference.child("talents").child("category").child(passedCategory!).child(passedTID!).child("ttext")
        detailLabelRef.observeSingleEvent(of: .value) { (snapshot) in
            let detailText: String = snapshot.value as! String
            self.profileDetailLabel.text = detailText
        }
        
        setThumbnail()
        
        
    }
    
//    let gradientLayer: CAGradientLayer = {
//
//        return gradientLayer
//    }()
    
    func fetchProfileImage() {
        let ref = reference.child("talents").child("category").child(passedCategory!).child(passedTID!).child("tfile")
        ref.observe(.value) { (snapshot) in
            
            let url: String = snapshot.value as! String
            let imageUrl: URL = URL(string: url)!
            print(imageUrl)
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    print("順調だよ！")
                    self.profileImage.image = UIImage(data: data!)
                }
            }.resume()
        }
    }
    
    
    
    var purchaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "95D2E1", alpha: 1)
        button.setTitle("購入する！", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false

        
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc func onClick() {
//        let informationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "infomationVC") as UIViewController
//        self.present(informationVC, animated: true, completion: nil)
//        self.show(informationVC, sender: self)
        performSegue(withIdentifier: "goToInfomationController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfomationController"{
            let infomationVC: informationController = (segue.destination as? informationController)!
            // SubViewController のselectedImgに選択された画像を設定する
            infomationVC.passedTID = passedTID
    }
    }
    
    func setThumbnail() {
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/IMG_5423.MOV?alt=media&token=b4027c05-538e-4edf-b312-3c5d55e4f84d") {
            let image = thumnailImageForFileUrl(fileUrl: url)
//            image?.imageOrientation = image!.imageOrientation
            self.videoButton1.setImage(image, for: .normal)
        }
    }
    
    
    func updateNameCategoryLabel(){
        
    }
    
    @IBAction func followButton(_ sender: Any) {
        
    }
    
    
    
    @IBAction func buttonToSeeAllReaction(_ sender: Any) {
        
    }
    
    @IBAction func testButton(_ sender: Any) {
        
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "t.dance666@gmail.com"
        smtpSession.password = "R0ck8910"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "ユーザー", mailbox: "so888tk@gmail.com")]
        builder.header.from = MCOAddress(displayName: "PUSH運営", mailbox: "t.dance666@gmail.com")
        builder.header.subject = "mailCoreテスト"
        builder.htmlBody="<p>こんにちわわわ！！！</p>"
        
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
                
                
            } else {
                NSLog("Successfully sent email!")
                
                
            }
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func videoButton1(_ sender: Any) {
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/push-bc760.appspot.com/o/SampleVideo_1280x720_10mb.mp4?alt=media&token=4b394063-3ce0-426a-9b28-abd9d2d7a748") {
            let video = AVPlayer(url: url)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            present(videoPlayer, animated: true) {
                video.play()
            }
        }
    }
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
}
}
