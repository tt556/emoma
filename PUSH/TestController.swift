//
//  TestController.swift
//  PUSH
//
//  Created by Taiki Kanzaki on 2019/04/15.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase

class TestController: UIViewController {

    @IBOutlet weak var testImageView: UIImageView!
    
    let tarentsRef = Database.database().reference().child("talents")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpImage()
    }
    
    func setUpImage() {
        let imageUrl = tarentsRef.child("category").child("YouTuber").child("-LcUqTRrrUf-SFf_6TWu").child("tfile")
        imageUrl.observe(.value) { (url) in
            
            print(url)
            
            let stringUrl = url.value as! String
            let Url = URL(string: stringUrl)
            self.testImageView.sd_setImage(with: Url)
            
//            let stringurl = url.value as! URL
//            do {
//                let imageData: Data = try Data(contentsOf: stringurl)
//                self.testImageView.image = UIImage(data: imageData)
//
//            } catch {
//                print(error)
//            }



        }
        
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
