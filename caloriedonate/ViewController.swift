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
    
    var pieView:PieView!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面中央
        let posX: CGFloat = self.view.bounds.width/2
        let posY: CGFloat = self.view.bounds.height/2
        
        var baseCal = 1800
        var nowCal = 2100
        
        let underColor:UIColor = UIColor.rgb(r: 0, g: 179, b: 198, alpha: 1.0);
        let overColor:UIColor = UIColor.rgb(r: 206, g: 8, b: 77, alpha: 1.0);
        
        // Do any additional setup after loading the view, typically from a nib.
        var params = [Dictionary<String,AnyObject>]()
        params.append(["value":7 as AnyObject,"color":UIColor.red])
        params.append(["value":5 as AnyObject,"color":UIColor.blue])
        params.append(["value":8 as AnyObject,"color":UIColor.green])
        params.append(["value":10 as AnyObject,"color":UIColor.yellow])
        pieView = PieView(frame: CGRect(x: 60, y: 100, width: 250, height: 250), cal: CGFloat(nowCal), max: CGFloat(baseCal))
        self.view.addSubview(pieView)
        
        var nowcolor:UIColor
        if(nowCal > baseCal){
            nowcolor = underColor
        } else {
            nowcolor = overColor
        }
        
        
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


}

