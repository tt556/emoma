//
//  InfomationController+handlers.swift
//  PUSH
//
//  Created by Taiki Kanzaki on 2019/04/10.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase
import Stripe

extension informationController {
    
    //注文時のデータをDatabaseのOrder階層の下に入れる。
    //orderIDを注文したユーザー、注文されたタレントのDBの下に格納 -> 購入履歴や予約履歴が観れるように
    func inputOrderText(TID: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM HH:mm:ss", options: 0, locale: Locale(identifier: "ja_JP"))
        let now = formatter.string(from: Date())
        print("これは現在時刻です\(now)")
        
        let ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid

        let orderRef = ref.child("order").childByAutoId()
        let usersRefForOrder = ref.child("users").child(uid!).child("orderInThePast").child(now)
        let talentsRefForOrder = ref.child("talents").child("category").child("YouTuber").child(TID).child("orderInThePast").child(now)
        
        usersRefForOrder.setValue(orderRef.key!)
        talentsRefForOrder.setValue(orderRef.key!)

        
        let indexForWho = forWhoSegmentControll.selectedSegmentIndex
        
        if let text = inputForVideoContentTextView.text {
            let values1: [String: Any] = ["IndexForWho": indexForWho, "to": toTextField.text!,"orderTextData": text]
            let values2: [String: Any] = ["IndexForWho": indexForWho, "to": toTextField.text!, "from": toTextField.text!, "orderTextData": text]
            
            if indexForWho == 0 {
                orderRef.updateChildValues(values1) { (err, orderRef) in
                    
                    if err != nil {
                        print("データベース失敗！！")
                        print(err)
                        return
                    }
                    
                }
            } else {
                orderRef.updateChildValues(values2) { (err, orderRef) in
                    
                    if err != nil {
                        print("データベース失敗！！")
                        print(err)
                        return
                    }
                }
            }
            
        
        }
        
    }
    
    func fetchVideoUrl() {
//        reference.child(category).child(tid).child("videoUrl").child(number).observe
    }
    
    func sendMail(text: String, email: String, userName: String) {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "emoma.official@gmail.com"
        smtpSession.password = "emoemo01"
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
        builder.header.to = [MCOAddress(displayName: userName, mailbox: email)]
        builder.header.from = MCOAddress(displayName: "emoma![エモマ]運営", mailbox: "emoma.official@gmail.com")
        builder.header.subject = "emoma!ご予約完了のお知らせ"
        builder.htmlBody="<p>この度はemoma!でのご予約ありがとうございます！</p><p>これはtextの内容です\(text)"
        
        
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
    //こっからはstripeのテスト関数
    
//    func TestSaveUIDToFireStore(){
//        var uid = Auth.auth().currentUser?.uid
//        let data = stripeCustomer.data
//        defaultStore.collection("stripe_customers").document(uid!).setData(data){ err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//    }
    
//    func TestCreateSources(){
//        var uid = Auth.auth().currentUser?.uid
//        var data = stripeCustomer.data
//        defaultStore.collection("stripe_customers").document(uid!).collection("sources").addSnapshotListener { (querySnapshot, error) in
//
//            guard let documents = querySnapshot?.documents else {
//                print("Error fetching documents: \(error!)")
//                return
//            }
//            for i in 0 ..< documents.count {
//                var newSource: [String: Any] = [:]
//                let documentID = documents[i].documentID
//                newSource[documentID] = documents[i].data()
//                data["sources"] = newSource
//
//                print("Sources \(data["sources"])")
//            }
//        }
//    }
//
//    func TestCreateCharges(){
//        var uid = Auth.auth().currentUser?.uid
//        var data = stripeCustomer.data
//        defaultStore.collection("stripe_customers").document(uid!).collection("charges").addSnapshotListener { (querySnapshot, error) in
//
//            guard let documents = querySnapshot?.documents else {
//                print("Error fetching documents: \(error!)")
//                return
//            }
//            for i in 0 ..< documents.count {
//                var newCharges: [String: Any] = [:]
//                let documentID = documents[i].documentID
//                newCharges[documentID] = documents[i].data()
//                data["charges"] = newCharges
//
//                print("Charges \(data["charges"])")
//            }
//        }
//    }
    
    
    

    
    func writeCustomerDataToFirestore(amount: Int, currency: String){
        let data:[String: Any] = [
            "amount": amount,
            "currency": currency
        ]
        if let uid = Auth.auth().currentUser?.uid{

            defaultStore.collection("stripe_customers").document(uid).collection("charges").addDocument(data: data)
        }else{
            print("uid取得失敗")
        }
    }
    
    
    
}
