//
//  ViewController.swift
//  Swift5 Bokete
//
//  Created by 平林宏淳 on 2020/04/30.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {

    
    @IBOutlet weak var odaiImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.layer.cornerRadius = 20.0
        PHPhotoLibrary.requestAuthorization{(states) in
            
            switch(states){
                case .authorized: break
                case .denied: break
                case . notDetermined: break
                case . restricted: break

            }
            
            self.getImages(keyword: "funny")


        }
        //謎
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        commentTextField.inputAccessoryView = toolBar
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spaceArea = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [spaceArea, doneButton]

    }
    
    //謎
       @objc func doneButtonTapped(){
       self.view.endEditing(true)
       }

    //検索キーをもとに画像を引っ張ってくる
    func getImages(keyword:String){
        
        let url = "https://pixabay.com/api/?key=2963093-768f9ffc11d874c5a568a82ee&q=\(keyword)"
        //Alamofireを使ってhttpsリクエストを投げる
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response) in
            
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as! Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                if imageString == nil{
                    
                    imageString = json["hits"][0]["webformatURL"].string
                     self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                    
                }else{
                    
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                    
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func nextOdai(_ sender: Any) {
        
        count = count + 1
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
            
        }else{
            
            getImages(keyword: searchTextField.text!)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        self.count = 0
        if searchTextField.text == ""{
            
       getImages(keyword: "funny")
            
        }else{
            
            getImages(keyword: searchTextField.text!)
        }
    }
    
    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as! ShareViewController
        shareVC.commentString = commentTextField.text
        shareVC.resultImage = odaiImageView.image!
        
    }
    
    
}

