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

    var _calorie:CGFloat!
    
    var _max: CGFloat!
    
    var _end_angle:CGFloat = -CGFloat(M_PI/2)
    
    func update(link:AnyObject){
        var angle = CGFloat(M_PI*2.0 / 100.0);
        _end_angle = _end_angle +  angle
        print(_end_angle)
        if(_end_angle > CGFloat(M_PI*2)) {
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
    
    
    init(frame: CGRect,cal: CGFloat, max:CGFloat) {
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
            end_angle = start_angle + CGFloat(M_PI*2) * (_calorie / _max);
        } else {
            color = overColor;
            bcolor = underColor;
            end_angle = start_angle + CGFloat(M_PI*2) * ((_calorie - _max) / _max);
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
        context.move(to: CGPoint(x: 200, y: 80))
        context.addLine(to: CGPoint(x: 55, y: 175))
        context.strokePath();
        
        context.setShadow(offset: CGSize(width: 1.0, height: 1.0), blur: CGFloat(6.0));
        
    }


}
