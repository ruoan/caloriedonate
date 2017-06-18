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

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
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
        btn1.addTarget(self, action: #selector(self.gotoHistory), for: .touchUpInside)
        
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
        
        self.view.addSubview(btn2)
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
    
    
    internal func gotoHistory(sender: UIButton){
        
        // 遷移するViewを定義する.
        let historyViewController: UIViewController = HistoryViewController()
        
        // アニメーションを設定する.
        historyViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Viewの移動する.
        self.present(historyViewController, animated: true, completion: nil)
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


}

