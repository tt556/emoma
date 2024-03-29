//
//  StandardVC.swift
//  StripePayment
//
//  Created by Harendra Sharma on 16/06/18.
//  Copyright © 2018 Harendra Sharma. All rights reserved.
//

import UIKit
import Stripe
import Firebase

class StandardVC: UIViewController, STPAddCardViewControllerDelegate {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var msgBox: UITextView!
    lazy var functions = Functions.functions()
    @IBOutlet weak var test: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Standard"
         msgBox.text = ""
        
      
        // Do any additional setup after loading the view.
    }
    @IBAction func addButton(_ sender: Any) {
        functions.httpsCallable("ssrapp").call(["amount": test.text]) { (result, error) in
            if let text = (result?.data as? [String: Any])?["amount"] as? String {
                self.label1.text = text
                print(result)
            }
        }
    }
    
    @IBAction func PaymentTapped(_ sender: UIButton) {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        
        print("Printing Strip response:\(token.allResponseFields)\n\n")
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Firestore.firestore().collection("stripe_customers").document(uid!).collection("sources")
        storageRef.addDocument(data: token.allResponseFields as! [String : Any])
        
        print("Printing Strip Token:\(token.tokenId)")
        let storageRef2 = Firestore.firestore().collection("stripe_customers").document(uid!).collection("tokens")
        storageRef2.addDocument(data: ["token": token.tokenId])
        
        msgBox.text = "Transaction success! \n\nHere is the Token: \(token.tokenId)\nCard Type: \(token.card!.funding.rawValue)\n\nSend this token or detail to your backend server to complete this payment."
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
