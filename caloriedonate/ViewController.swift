//
//  ViewController.swift
//  caloriedonate
//
//  Created by y-okada on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pieView:PieView!
    var leftCircle:CircleView!
    
    var tableView: UITableView!
    
    var btn1: UIButton!
    var btn2: UIButton!
    
    let menu = ["唐揚げ","パン","牛タン定食","牛タン定食","牛タン定食"]
    let foodcal = [850.0,150.0,740.0,740.0,740.0]
    
    let iconcamera :UIImage? = UIImage(named:"photo-camera.png")
    let iconoption :UIImage? = UIImage(named:"listing-option.png")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面中央
        let posX: CGFloat = self.view.bounds.width/2
        let posY: CGFloat = self.view.bounds.height/2
        
        var baseCal:Int = 1800
        var nowCal:Int = 1600
        
        
        //パイチャートカラー定義
        let underColor:UIColor = UIColor.rgb(r: 0, g: 179, b: 198, alpha: 1.0);
        let overColor:UIColor = UIColor.rgb(r: 206, g: 8, b: 77, alpha: 1.0);
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        
        let leftColor:UIColor = UIColor.rgb(r: 8, g: 206, b: 199, alpha: 1.0);
        
        //背景色
        self.view.backgroundColor = bgColor
        
        //パイチャート描画
        pieView = PieView(frame: CGRect(x: 45, y: 90, width: 230, height: 230), cal: nowCal, max: baseCal)
        self.view.addSubview(pieView)
        
        
        var nowcolor:UIColor
        if(nowCal > baseCal){
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
        if(baseCal > nowCal){
            leftstr = "Clear"
        } else {
            leftstr = String(nowCal - baseCal) + "円"
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
        
        
        
        //テーブルビュー
        var tableoffset:CGFloat = 330
        tableView = UITableView(frame:CGRect(x:0,y:tableoffset,width:self.view.bounds.width,height:self.view.bounds.height - tableoffset))
        tableView.backgroundColor = bgColor
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        self.view.addSubview(btn2)
        
        
    }
    
    // セルを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        //cell.imageView = ""
        cell.backgroundColor = bgColor
        cell.textLabel?.text = "\(foodcal[indexPath.row]) kcal"
        cell.detailTextLabel?.text = "\(menu[indexPath.row])"
        //cell.accessoryType = .detailButton
        
        return cell
    }
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pieView.startAnimating()
        }
        
    }


}

