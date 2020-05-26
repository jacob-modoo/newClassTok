//
//  LineProgressBar.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/31.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class LineProgressBar: NSObject {
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let dotLayer = CAShapeLayer()
    let dotBoardLayer = CAShapeLayer()
    let goalLayer = CAShapeLayer()
    let textlayer = ECATextLayer()
    var circleView:UIView = UIView.init(frame: CGRect.zero)
    
    func lineAddProgress(width:CGFloat,height:CGFloat,progress:CGFloat,golePoint:CGFloat,myProgress:CGFloat,action:Bool) -> UIView{
        circleView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        let center = circleView.center
        
//        let circularPath = UIBezierPath(arcCenter: center, radius: 0, startAngle:  0, endAngle: 180, clockwise: false)
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: height/2))
        linePath.addLine(to: CGPoint(x: width, y: height/2))
        
        trackLayer.path = linePath.cgPath
        trackLayer.strokeColor =  UIColor(named: "BackColor_mainColor")?.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 5
        trackLayer.lineCap = .round
        circleView.layer.addSublayer(trackLayer)
        
        // 이건 그룹 퍼센트
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor(hexString: "#FFB95A").cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = progress
        shapeLayer.lineCap = .round
        circleView.layer.addSublayer(shapeLayer)
        
        //이건 내 퍼센트
        goalLayer.path = linePath.cgPath
        goalLayer.strokeColor = UIColor(hexString: "#FFE1A7").cgColor//(named: "MainPoint_mainColor")?.cgColor
        goalLayer.fillColor = UIColor.clear.cgColor
        goalLayer.lineWidth = 5
        goalLayer.strokeStart = 0
        goalLayer.strokeEnd = myProgress//golePoint
        goalLayer.lineCap = .round
        circleView.layer.addSublayer(goalLayer)

        dotBoardLayer.path = linePath.cgPath
        dotBoardLayer.strokeColor =  UIColor.white.cgColor
        dotBoardLayer.fillColor = UIColor.clear.cgColor
        dotBoardLayer.lineWidth = 6
        dotBoardLayer.strokeStart = golePoint - 0.001
        dotBoardLayer.strokeEnd = golePoint
        dotBoardLayer.lineCap = .round
        circleView.layer.addSublayer(dotBoardLayer)

        dotLayer.path = linePath.cgPath
        dotLayer.strokeColor = UIColor(named: "MainPoint_mainColor")?.cgColor
        dotLayer.fillColor = UIColor.clear.cgColor
        dotLayer.lineWidth = 5
        dotLayer.strokeStart = golePoint - 0.001
        dotLayer.strokeEnd = golePoint
        dotLayer.lineCap = .round
        circleView.layer.addSublayer(dotLayer)
        
        let textX:CGFloat = width * golePoint - 35
        let textY:CGFloat = height
        textlayer.frame = CGRect(x: textX, y: textY, width: 80, height: 20)
        textlayer.fontSize = 12.5
        textlayer.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12.5)!
        textlayer.alignmentMode = .center
        textlayer.string = "그룹목표 \(Int(round(golePoint*100)))%"
        textlayer.isWrapped = false
        textlayer.truncationMode = .none
        textlayer.backgroundColor = UIColor(hexString: "#FFF7F7").cgColor
        textlayer.foregroundColor = UIColor(named: "MainPoint_mainColor")?.cgColor//UIColor(hexString: "#25E9AD").cgColor
        textlayer.cornerRadius = 5
        textlayer.contentsScale = UIScreen.main.scale
        textlayer.convert(dotLayer.position, to: dotLayer)
        circleView.layer.addSublayer(textlayer)

        if action == true{
            shapeLayer.strokeEnd = 0//progress
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = progress
            basicAnimation.duration = 2
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            shapeLayer.add(basicAnimation,forKey: "urSoBasic")
        }else{
            shapeLayer.strokeEnd = progress
        }
        
        return circleView
    }
    
    func point(progress: CGFloat, radius: CGFloat) -> CGPoint {
        let x = radius * (1 + CGFloat(sin(progress * 2 * CGFloat.pi)))
        let y = radius * (1 - CGFloat(cos(progress * 2 * CGFloat.pi)))

        return CGPoint(x: x-15, y: y-15)
    }
    deinit {
        print("LineProgressBar deinit")
    }
}
