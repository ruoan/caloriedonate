//
//  PieView.swift
//  caloriedonate
//
//  Created by ruoan on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
    
    var _start:CGFloat!
    
    var _end: CGFloat!
    
    var _width: CGFloat!
    
    var _color: UIColor!
    
    var _clockwise: Bool!
    
    
    init(frame: CGRect,start: CGFloat, end:CGFloat, width:CGFloat, color: UIColor, clockwise: Bool) {
        super.init(frame: frame)
        _start = start
        _end = end
        _width = width
        _color = color
        _clockwise = clockwise
        
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2;
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/2;

        let center = CGPoint(x: x, y: y);
        
        print(_start)
        
        let _radius:CGFloat = rect.size.width/2 - _width;
        
        context.setLineWidth(_width);
        
        context.addArc(center:center,
                       radius: _radius,
                       startAngle: _start,
                       endAngle: _end,
                       clockwise: _clockwise);
        context.setStrokeColor(_color.cgColor);
        context.strokePath();

        
    }
    
    
}
