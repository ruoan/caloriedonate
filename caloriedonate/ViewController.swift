//
//  ViewController.swift
//  caloriedonate
//
//  Created by y-okada on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AWSS3
import Photos

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pieView:PieView!
    var leftCircle:CircleView!
    
    var tableView: UITableView!
    
    var btn1: UIButton!
    var btn2: UIButton!
    
    var today: [[String: String]] = []
    
    let iconcamera :UIImage? = UIImage(named:"photo-camera")
    let iconoption :UIImage? = UIImage(named:"listing-option")
    
    var baseCal:Int? = 1800
    var nowCal:Int? = 0
    
    let CACHE_SEC : TimeInterval = 5 * 60; //5分キャッシュ

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データ取得
        self.getJson()
        
        //画面中央
        let posX: CGFloat = self.view.bounds.width/2
        let posY: CGFloat = self.view.bounds.height/2
        
        //カラー定義
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        
        
        //背景色
        self.view.backgroundColor = bgColor
        
        
        
        
    }
    
    func afterGetjson(){
        
        let underColor:UIColor = UIColor.rgb(r: 0, g: 179, b: 198, alpha: 1.0);
        let overColor:UIColor = UIColor.rgb(r: 206, g: 8, b: 77, alpha: 1.0);
        let leftColor:UIColor = UIColor.rgb(r: 8, g: 206, b: 199, alpha: 1.0);
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        
        var nowcolor:UIColor
        if(self.nowCal! > self.baseCal!){
            nowcolor = overColor
        } else {
            nowcolor = underColor
        }
        
        
        //サークル
        let lstart:CGFloat = -CGFloat(M_PI/2) + CGFloat(M_PI*2) * 0.23;
        let lend:CGFloat = -CGFloat(M_PI/2) + CGFloat(M_PI*2) * 0.57;
        
        leftCircle = CircleView(frame: CGRect(x: 20, y: 40, width: 140, height: 140),
                                start:lstart,end:lend,width: CGFloat(5.0),color: leftColor, clockwise: true)
        self.view.addSubview(leftCircle)
        
        //左上文字列
        var leftstr:String
        if(baseCal! > nowCal!){
            leftstr = "Clear"
        } else {
            leftstr = String(nowCal! - baseCal!) + "円"
        }
        
        let labelleft: UILabel = UILabel(frame: CGRect(x: 30,
                                                       y: 80,
                                                       width: 120,
                                                       height: 30))
        labelleft.textColor = leftColor
        //labelleft.backgroundColor = UIColor.red;
        labelleft.font = UIFont(name: "HiraKakuProN-W6",size: 24)
        labelleft.textAlignment = NSTextAlignment.center
        labelleft.text = leftstr
        self.view.addSubview(labelleft)
        
        //テーブルビュー
        var tableoffset:CGFloat = 330
        tableView = UITableView(frame:CGRect(x:0,y:tableoffset,width:self.view.bounds.width,height:self.view.bounds.height - tableoffset))
        tableView.backgroundColor = bgColor
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        //右上ボタン
        btn1 = UIButton()
        btn1.frame = CGRect(x: self.view.bounds.width - 80,
                            y: 80,
                            width: 60,
                            height: 60)
        btn1.setImage(iconoption, for: UIControlState.normal)
        
        let btn1Color:UIColor = UIColor.rgb(r: 255, g: 255, b: 255, alpha: 1.0)
        btn1.backgroundColor = btn1Color
        
        btn1.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn1.layer.shadowColor = UIColor.rgb(r: 100, g: 100, b: 100, alpha: 1.0).cgColor
        btn1.layer.shadowOpacity = 0.7
        btn1.layer.shadowRadius = 3.0
        btn1.layer.cornerRadius = 30.0
        
        self.view.addSubview(btn1)
        
        //右上ボタン
        btn2 = UIButton()
        btn2.frame = CGRect(x: self.view.bounds.width - 80,
                            y: 270,
                            width: 60,
                            height: 60)
        btn2.setImage(iconcamera, for: UIControlState.normal)
        
        btn2.backgroundColor = underColor
        
        btn2.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn2.layer.shadowColor = UIColor.rgb(r: 100, g: 100, b: 100, alpha: 1.0).cgColor
        btn2.layer.shadowOpacity = 0.7
        btn2.layer.shadowRadius = 3.0
        btn2.layer.cornerRadius = 30.0
        btn2.addTarget(self, action: #selector(self.selectImage(_:)), for: .touchUpInside)
        
        self.view.addSubview(btn2)
        
        setUpActivityIndicator()
        setupImageView()
    }
    
    func getJson() -> JSON{
        var json:JSON = JSON("")
        let URL = "https://74sgw22ebg.execute-api.ap-northeast-1.amazonaws.com/dev/calorie"
        Alamofire.request(URL, parameters: ["date":"2017-06-17"])
            .responseJSON { response in
                json = JSON(response.result.value)
                
                
                json["body"].forEach{(_, data) in
                    
                    self.nowCal = self.nowCal! + data["calorie"].intValue
                    
                    let food: [String: String] = [
                        "menu": data["menu_name"].stringValue,
                        "cal": data["calorie"].description,
                        "img": data["url"].stringValue
                    ]
                    self.today.append(food)
                    
                }
                
                print(self.nowCal)
                
                //パイチャート描画
                self.pieView = PieView(frame: CGRect(x: 45, y: 90, width: 230, height: 230), cal: self.nowCal!, max: self.baseCal!)
                self.view.addSubview(self.pieView)
                
                self.afterGetjson()
                
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.pieView.startAnimating()
                //}
                
        }
        
        return json
    }
    
    
    
    // セルを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        //cell.imageView = ""
        cell.backgroundColor = bgColor
        let t = today[indexPath.row]
        cell.textLabel?.text = t["cal"]! + "kcal"
        cell.detailTextLabel?.text = t["menu"]!
        print(t["img"])
        let url = NSURL(string: t["img"]!);
        var imageData = NSData(contentsOf: url as! URL)
        var img = UIImage(data:imageData as! Data);
        cell.imageView?.image = img
        //cell.accessoryType = .detailButton
        
        return cell
    }
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(today != nil){
            return today.count
        }else {
            return 0
        }
    }
    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    func selectImage(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImageUrl = nil;
        localIdentifier = nil;
        
        if let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL {
            selectedImageUrl = imageUrl
            myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            myImageView.backgroundColor = UIColor.clear
            myImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            startUploadingImage()
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            myImageView.image = image
            myImageView.backgroundColor = UIColor.clear
            myImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            var imageAssetPlaceholder:PHObjectPlaceholder!
            PHPhotoLibrary.shared().performChanges({
                
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                imageAssetPlaceholder = request.placeholderForCreatedAsset
            }, completionHandler: { success, error in
                if success {
                    // Saved successfully!
                    print("success")
                    self.localIdentifier = imageAssetPlaceholder.localIdentifier
                    /*
                     let assetID =
                     localID.replacingOccurrences(
                     of: "/.*", with: "",
                     options: NSString.CompareOptions.regularExpression, range: nil)
                     print(assetID)
                     self.selectedImageUrl = NSURL(fileURLWithPath: "assets-library://asset/asset.JPG?id=" + assetID + "&ext=JPG")
                     */
                    
                    self.startUploadingImage()
                }
                else if let error = error {
                    // Save photo failed with error
                    print(error)
                }
                else {
                    // Save photo failed with no error
                }
            })
        }
        
        self.dismiss(animated: true, completion: nil)

    }

    var showImagePickerButton: UIButton!
    var myImageView: UIImageView!
    var selectedImageUrl: NSURL?
    var localIdentifier:String?
    var myActivityIndicator: UIActivityIndicatorView!
    
    func startUploadingImage()
    {
        var localFileName:String?
        if let imageToUploadUrl = selectedImageUrl {
            let phResult = PHAsset.fetchAssets(withALAssetURLs: [imageToUploadUrl as URL], options: nil)
            localFileName = phResult.firstObject?.originalFilename
        } else if let localId = localIdentifier {
            let phResult = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil)
            localFileName = phResult.firstObject?.originalFilename
        }
        
        
        if localFileName == nil
        {
            print("5")
            return
        }
        
        myActivityIndicator.startAnimating()
        
        
        // Configure AWS Cognito Credentials
        let myIdentityPoolId = "ap-northeast-1:c5a730e3-d635-40fd-a313-54a704df2915"
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.APNortheast1, identityPoolId: myIdentityPoolId)
        
        
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.APNortheast1, credentialsProvider:credentialsProvider)
        
        
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        // Set up AWS Transfer Manager Request
        let S3BucketName = "meal.caloriedonate.com"
        
        let remoteName = localFileName!
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        
        uploadRequest.body = generateImageUrl(fileName: remoteName) as URL
        uploadRequest.key = remoteName
        uploadRequest.bucket = S3BucketName
        uploadRequest.contentType = "image/jpeg"
        
        print(remoteName)
        
        let transferManager = AWSS3TransferManager.default()
        // Perform file upload
        
        transferManager.upload(uploadRequest).continueWith { (task) -> AnyObject! in
            
           
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
            }
            
            if task.result != nil {
                
                let s3URL = NSURL(string: "https://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
                print("Uploaded to:\n\(s3URL)")
                // Remove locally stored file
                self.remoteImageWithUrl(fileName: uploadRequest.key!)
                
                
                self.callEinsteinVision(imagUrl: "https://s3-ap-northeast-1.amazonaws.com/meal.caloriedonate.com/\(remoteName)")
                
                
                
                
            } else {
                print("Unexpected empty result.")
            }
            return nil
        }
        
    }
    
    func displayAlertMessage(message:String)
    {
        let alertController = UIAlertController(title: "アップロード完了", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    func generateImageUrl(fileName: String) -> NSURL
    {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        let data = UIImageJPEGRepresentation(myImageView.image!, 0.6)
        do {
            try data!.write(to: fileURL as URL, options: .atomic)
        } catch {
            print(error)
        }
        return fileURL
    }
    
    func remoteImageWithUrl(fileName: String)
    {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        do {
            try FileManager.default.removeItem(at: fileURL as URL)
        } catch
        {
            print(error)
        }
    }
    
    
    func setupImageView()
    {
        myImageView = UIImageView()
        
        let xPostion:CGFloat = 50
        let yPostion:CGFloat = 200
        let buttonWidth:CGFloat = 200
        let buttonHeight:CGFloat = 200
        
        myImageView.frame = CGRect(x: xPostion, y: yPostion, width: buttonWidth, height: buttonHeight)
        
        //self.view.addSubview(myImageView)
    }
    
    
    func setUpActivityIndicator()
    {
        //Create Activity Indicator
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        myActivityIndicator.backgroundColor = UIColor.white
        
        view.addSubview(myActivityIndicator)
    }
    
    func callEinsteinVision(imagUrl: String!) {
        
        let url = "https://api.einstein.ai/v1/vision/predict"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer 122ce80ff90d201ca9491321331e923cd883881c",
            "Cache-Control": "no-cache",
            "Content-Type": "multipart/form-data",
            ]
        
        
        Alamofire.upload(
            multipartFormData: { (multipartFormData) in
                multipartFormData.append("Photo Prediction".data(using: String.Encoding.utf8)!, withName: "sampleId")
                multipartFormData.append(imagUrl.data(using: String.Encoding.utf8)!, withName: "sampleLocation")
                multipartFormData.append("MVYDZWN5B2XBUAMIM6AAURFBBY".data(using: String.Encoding.utf8)!, withName: "modelId")
                
        },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.result.value)
                        print("YOUR JSON DATA>>  \(json["probabilities"][0]["label"])")

                       self.postCalorie(calorie: json["probabilities"][0]["label"].stringValue, url: imagUrl, menu: "唐揚げ弁当")
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }

    
    func postCalorie(calorie: String, url: String, menu: String) -> Bool{
        var json:JSON = JSON("")
        let URL = "https://74sgw22ebg.execute-api.ap-northeast-1.amazonaws.com/dev/calorie"
        let parameters = [
            "calorie": calorie,
            "url": url,
            "menu": menu,
            
            ] as [String : Any]
        Alamofire.request(URL, method: .post, parameters: parameters)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                DispatchQueue.main.async() {
                    self.myActivityIndicator.stopAnimating()
                    self.displayAlertMessage(message: "\(menu) は \(calorie) kcal でした。")
                }
                self.getJson()
                
        }
        return true
    }

}

