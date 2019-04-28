//
//  ProfileController+handlers.swift
//  PUSH
//
//  Created by Taiki Kanzaki on 2019/04/17.
//  Copyright © 2019 taiki. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit



extension ProfileController {
    
    func calculate() {
        
        let array:[UIButton] = [videoButton0, videoButton1, videoButton2, videoButton3, videoButton4, videoButton5, videoButton6, videoButton7, videoButton8, videoButton9]
        
        let videoRef = reference.child("talents/category/\(passedCategory!)/\(passedTID!)/videoURL")
        videoRef.observe(.value) { (snapshot) in
            let numChildren = Int(snapshot.childrenCount)
            
            if numChildren <= 10 {
                for i in (1...numChildren).reversed(){
                    videoRef.child("\(i)").observe(.value, with: { (snapshot) in
                        if let url: URL = URL(string: snapshot.value as! String){
//                            let image = self.thumnailImageForFileUrl(fileUrl: url)
//                            let button: UIButton = array[i - 1]
//                            button.setImage(image, for: .normal)
                            let button: UIButton = array[i - 1]
                            AVAsset(url: url).generateThumbnail { [weak self] (image) in
                                DispatchQueue.main.async {
                                    guard let image = image else { return }
                                    button.setImage(image, for: .normal)
                                }
                            }
                        }
                        
                    }
                )}
            }else{
            for i in (numChildren...numChildren - 10).reversed() {
                videoRef.child("\(i)").observe(.value, with: { (snapshot) in
                    if let url: URL = URL(string: snapshot.value as! String){
                        let image = self.thumnailImageForFileUrl(fileUrl: url)
                        
                        //for文が回った回数-1がarrayのindexに対応すれば良い
                        var index = 0
                        let button: UIButton = array[index]
                        index = index + 1
                        AVAsset(url: url).generateThumbnail { [weak self] (image) in
                            DispatchQueue.main.async {
                                guard let image = image else { return }
                                button.setImage(image, for: .normal)
                            }
                        }
                    }
                })
            }
            }
        }
    }
    //-MARK: 動画のための関数
    func fethVideoURLAndPlayVideo(selectedButton: UIButton) {
        let array:[UIButton] = [videoButton0, videoButton1, videoButton2, videoButton3, videoButton4, videoButton5, videoButton6, videoButton7, videoButton8, videoButton9]
        
        let videoRef = reference.child("talents/category/\(passedCategory!)/\(passedTID!)/videoURL")
        videoRef.observe(.value) { (snapshot) in
            let numChildren = Int(snapshot.childrenCount)
            if numChildren <= 10 {
                for i in (1...numChildren).reversed(){
                    videoRef.child("\(i)").observe(.value, with: { (snapshot) in
                        if let url: URL = URL(string: snapshot.value as! String){
                            self.videoPlay(url: url)
                        }
                        
                    }
                    )}
            }else{
                for i in (numChildren...numChildren - 10).reversed() {
                    videoRef.child("\(i)").observe(.value, with: { (snapshot) in
                        if let url: URL = URL(string: snapshot.value as! String){
                            let image = self.thumnailImageForFileUrl(fileUrl: url)
                            var index = 0
                            let button: UIButton = array[index]
                            index = index + 1
                            button.setImage(image, for: .normal)
                        }
                        
                    })
                }
            }
        }
    }
    
    func videoPlay(url: URL){
        let video = AVPlayer(url: url)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = video
        self.present(videoPlayer, animated: true, completion: nil)
    }
    
    func setThumbnail() {
        let urlRef = reference.child("talents/category/\(passedCategory!)/\(passedTID!)/videoURL/3")
//        let number = urlRef.accessibilityElementCount()
//        print("これはアクセス可能な値の数です" ,number)
        urlRef.observe(.value) { (snapshot) in
            let a = snapshot.value as! String
            if let url: URL = URL(string: a){
                let image = self.thumnailImageForFileUrl(fileUrl: url)
                self.videoButton1.setImage(image, for: .normal)
            }
        }
    }

     func thumnailImageForFileUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)

        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
            print("サムネイル切り取り成功！")
            return UIImage(cgImage: thumnailCGImage, scale: 0, orientation: .right)
        }catch let err{
            print("エラーが起きました")
            print(err)
        }
        return nil
    }
    
    
    
    //テスト
//    func thumbnailImageFor(fileUrl:URL) -> UIImage? {
//
//        let video = AVURLAsset(url: fileUrl, options: [:])
//        let assetImgGenerate = AVAssetImageGenerator(asset: video)
//        assetImgGenerate.appliesPreferredTrackTransform = true
//
//        let videoDuration:CMTime = video.duration
//        let durationInSeconds:Float64 = CMTimeGetSeconds(videoDuration)
//
//        let numerator = Int64(1)
//        let denominator = videoDuration.timescale
//        let time = CMTimeMake(value: numerator, timescale: denominator)
//
//        do {
//            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
//            let thumbnail = UIImage(cgImage: img)
//            return thumbnail
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//
//    func setThumbnail(){
//
//                let urlRef = reference.child("talents/category/\(passedCategory!)/\(passedTID!)/videoURL/5")
//        //        let number = urlRef.accessibilityElementCount()
//        //        print("これはアクセス可能な値の数です" ,number)
//                urlRef.observe(.value) { (snapshot) in
//
//                    print(snapshot)
//                    let a = snapshot.value as! String
//                    if let url: URL = URL(string: a){
//                        let image = self.thumbnailImageFor(fileUrl: url)
//                        self.videoButton1.setImage(image, for: .normal)
//                        print("Image: \(image)")
//                    }
//                }
//
//
//    }
    
    
    func howMuchYourVideo() {
        
    }
    
    
    
}
