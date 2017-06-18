//
//  PieView.swift
//  caloriedonate
//
//  Created by ruoan on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import Foundation
import UIKit

class PieView: UIView {

    var _calorie: Int!
    
    var _max: Int!
    
    var _end_angle:CGFloat = -CGFloat(M_PI/2)
    
    func update(link:AnyObject){
        var angle = CGFloat(M_PI*5.0 / 100.0);
        var max:CGFloat
        
        if(_max > _calorie){
            max = -CGFloat(M_PI/2) + CGFloat(M_PI*2) * CGFloat(_calorie) / CGFloat(_max);
        } else {
            max = -CGFloat(M_PI/2) + CGFloat(M_PI*2) * (CGFloat(_calorie - _max) / CGFloat(_max));
        }
        
        
        _end_angle = _end_angle +  angle
        if(_end_angle > max) {
            //終了
            link.invalidate()
        } else {
            self.setNeedsDisplay()
        }
        
    }
    
    func startAnimating(){
        let displayLink = CADisplayLink(target: self, selector: #selector(self.update))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    
    init(frame: CGRect,cal: Int, max:Int) {
        super.init(frame: frame)
        _calorie = cal;
        _max = max;
        
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let baseColor:UIColor = UIColor.rgb(r: 210, g: 210, b: 210, alpha: 1.0);
        let underColor:UIColor = UIColor.rgb(r: 0, g: 179, b: 198, alpha: 1.0);
        let overColor:UIColor = UIColor.rgb(r: 206, g: 8, b: 77, alpha: 1.0);
        let lineColor:UIColor = UIColor.rgb(r: 180, g: 180, b: 180, alpha: 1.0);
        
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);

        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2;
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/2;
        
        let start_angle:CGFloat = -CGFloat(M_PI/2);
        var end_angle:CGFloat = 0
        let radius:CGFloat  = x - 20.0;
        let center = CGPoint(x: x, y: y);
        
        var color:UIColor;
        var bcolor:UIColor;
        if(_max > _calorie){
            color = underColor;
            bcolor = baseColor;
            end_angle = start_angle + CGFloat(M_PI*2) * CGFloat(_calorie) / CGFloat(_max);
        } else {
            color = overColor;
            bcolor = underColor;
            end_angle = start_angle + CGFloat(M_PI*2) * (CGFloat(_calorie - _max) / CGFloat(_max));
        }
        
        if(end_angle > _end_angle) {
            end_angle = _end_angle;
        }
        
        context.setLineWidth(10.0);
        //context.move(to: CGPoint(x: x, y: y));
        
        context.addArc(center:center,
                             radius: radius,
                             startAngle: start_angle,
                             endAngle: end_angle,
                             clockwise: false);
        context.setStrokeColor(color.cgColor);
        context.strokePath();
        
        
        context.addArc(center:center,
                      radius: radius,
                      startAngle: end_angle,
                      endAngle: start_angle,
                      clockwise: false);
        context.setStrokeColor(bcolor.cgColor);
        
        context.strokePath();
        
        context.setLineWidth(2.0)
        context.setStrokeColor(lineColor.cgColor)
        context.move(to: CGPoint(x: rect.origin.x + 40, y: rect.origin.y + rect.size.height/2 + 30))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - 40, y: rect.origin.y + rect.size.height/2 - 30))
        context.strokePath();
        
        let labelNow: UILabel = UILabel(frame: CGRect(x: rect.origin.x + 40,
                                                      y: rect.origin.y + rect.size.height/2 - 60,
                                                      width: rect.size.width - 80,
                                                      height: 50))
        labelNow.textColor = color
        //labelNow.backgroundColor = UIColor.red;
        labelNow.font = UIFont(name: "HiraKakuProN-W6",size: 36)
        labelNow.textAlignment = NSTextAlignment.left
        labelNow.text = _calorie.description
        
        let labelunit: UILabel = UILabel(frame: CGRect(x: rect.origin.x + rect.size.width/2 - 20,
                                                      y: rect.origin.y + rect.size.height/2 - 10,
                                                      width: 40,
                                                      height: 20))
        labelunit.textColor = UIColor.gray
        labelunit.backgroundColor = bgColor
        //labelNow.backgroundColor = UIColor.red;
        labelunit.font = UIFont(name: "HiraKakuProN-W6",size: 12)
        labelunit.textAlignment = NSTextAlignment.center
        labelunit.text = "kcal"
        
        let labelBase: UILabel = UILabel(frame: CGRect(x: rect.origin.x + 40,
                                                       y: rect.origin.y + rect.size.height/2 + 10,
                                                       width: rect.size.width - 80,
                                                       height: 50))
        labelBase.textColor = UIColor.gray
        //labelBase.backgroundColor = UIColor.blue;
        labelBase.font = UIFont(name: "HiraKakuProN-W6",size: 28)
        labelBase.textAlignment = NSTextAlignment.right
        labelBase.text = _max.description
        
        self.addSubview(labelNow)
        self.addSubview(labelunit)
        self.addSubview(labelBase)
        
    }


}
