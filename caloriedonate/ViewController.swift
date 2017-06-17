//
//  ViewController.swift
//  caloriedonate
//
//  Created by y-okada on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pieView:PieView!
    var leftCircle:CircleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面中央
        let posX: CGFloat = self.view.bounds.width/2
        let posY: CGFloat = self.view.bounds.height/2
        
        var baseCal = 1800
        var nowCal = 2100
        
        //パイチャートカラー定義
        let underColor:UIColor = UIColor.rgb(r: 0, g: 179, b: 198, alpha: 1.0);
        let overColor:UIColor = UIColor.rgb(r: 206, g: 8, b: 77, alpha: 1.0);
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        
        let leftColor:UIColor = UIColor.rgb(r: 8, g: 206, b: 199, alpha: 1.0);
        
        //背景色
        self.view.backgroundColor = bgColor
        
        //パイチャート描画
        pieView = PieView(frame: CGRect(x: 65, y: 100, width: 250, height: 250), cal: CGFloat(nowCal), max: CGFloat(baseCal))
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
        
        leftCircle = CircleView(frame: CGRect(x: 40, y: 50, width: 140, height: 140),
                                start:lstart,end:lend,width: CGFloat(5.0),color: leftColor, clockwise: true)
        self.view.addSubview(leftCircle)
        
        let labelNow: UILabel = UILabel(frame: CGRect(x: posX-75, y: 160, width: 150, height: 50))
        labelNow.textColor = nowcolor
        //labelNow.backgroundColor = UIColor.red;
        labelNow.font = UIFont(name: "HiraKakuProN-W6",size: 40)
        labelNow.textAlignment = NSTextAlignment.left
        labelNow.text = String(nowCal)
        
        let labelBase: UILabel = UILabel(frame: CGRect(x: posX-75, y: 240, width: 150, height: 50))
        labelBase.textColor = UIColor.gray
        //labelBase.backgroundColor = UIColor.blue;
        labelBase.font = UIFont(name: "HiraKakuProN-W6",size: 30)
        labelBase.textAlignment = NSTextAlignment.right
        labelBase.text = String(baseCal)
        
        self.view.addSubview(labelNow)
        self.view.addSubview(labelBase)
        
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

