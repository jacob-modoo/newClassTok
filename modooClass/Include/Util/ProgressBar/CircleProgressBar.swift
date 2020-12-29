//
//  CircleProgressBar.swift
//  modooClass
//
//  Created by 조현민 on 02/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

class CircleProgressBar {
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
//    let dotLayer = CAShapeLayer()
//    let dotBoardLayer = CAShapeLayer()
//    let goalLayer = CAShapeLayer()
//    let textlayer = ECATextLayer()
    var circleView:UIView = UIView.init(frame: CGRect.zero)
    
    func circleAddProgress(width:CGFloat,height:CGFloat,progress:CGFloat,golePoint:CGFloat,action:Bool) -> UIView{
        circleView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let center = circleView.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: height/2, startAngle:  -CGFloat.pi / 2, endAngle: CGFloat.pi + CGFloat.pi / 2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor =  UIColor(named: "BackColor_mainColor")?.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 5
        trackLayer.lineCap = .round
        circleView.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
//        if golePoint < progress{
//            shapeLayer.strokeColor = UIColor(named: "MainPoint_subColor2")?.cgColor//UIColor(hexString: "#25E9AD").cgColor
//        }else{
            shapeLayer.strokeColor = UIColor(named: "MainPoint_mainColor")?.cgColor//UIColor(hexString: "#7461f2").cgColor
//        }
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = progress
        shapeLayer.lineCap = .round
        circleView.layer.addSublayer(shapeLayer)
        
//        if golePoint < progress{
//            goalLayer.path = circularPath.cgPath
//            goalLayer.strokeColor = UIColor(named: "MainPoint_mainColor")?.cgColor
//            goalLayer.fillColor = UIColor.clear.cgColor
//            goalLayer.lineWidth = 5
//            goalLayer.strokeStart = 0
//            goalLayer.strokeEnd = golePoint
//            goalLayer.lineCap = .round
//            circleView.layer.addSublayer(goalLayer)
//        }
//
//        dotBoardLayer.path = circularPath.cgPath
//        dotBoardLayer.strokeColor =  UIColor.red.cgColor
//        dotBoardLayer.fillColor = UIColor.clear.cgColor
//        dotBoardLayer.lineWidth = 12.5
//        dotBoardLayer.strokeStart = golePoint - 0.001
//        dotBoardLayer.strokeEnd = golePoint
//        dotBoardLayer.lineCap = .round
//        circleView.layer.addSublayer(dotBoardLayer)
//
//        dotLayer.path = circularPath.cgPath
//        dotLayer.strokeColor = UIColor(named: "MainPoint_mainColor")?.cgColor
//        dotLayer.fillColor = UIColor.clear.cgColor
//        dotLayer.lineWidth = 10
//        dotLayer.strokeStart = golePoint - 0.001
//        dotLayer.strokeEnd = golePoint
//        dotLayer.lineCap = .round
//        circleView.layer.addSublayer(dotLayer)
        
//        let pointCheck = point(progress: golePoint, radius: height/2)
//        var textX:CGFloat = pointCheck.x
//        var textY:CGFloat = pointCheck.y
//        if pointCheck.x < width/2 {
//            if pointCheck.y < height/2{
//                // 1/4 지점
//                textX = pointCheck.x - 20
//                textY = pointCheck.y - 20
//            }else{
//                // 3/4 지점
//                textX = pointCheck.x - 20
//                textY = pointCheck.y + 20
//            }
//        }else{
//            if pointCheck.y < height/2{
//                // 2/4 지점
//                textX = pointCheck.x + 20
//                textY = pointCheck.y - 20
//            }else{
//                // 4/4 지점
//                textX = pointCheck.x + 20
//                textY = pointCheck.y + 20
//            }
//        }
        
//        textlayer.frame = CGRect(x: textX, y: textY-5, width: 30, height: 30)
//        textlayer.fontSize = 12
//        textlayer.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)!
//        textlayer.alignmentMode = .center
//        textlayer.string = "\(Int(round(golePoint*100)))%"
//        textlayer.isWrapped = false
//        textlayer.truncationMode = .none
//        textlayer.backgroundColor = UIColor.white.cgColor
//        textlayer.foregroundColor = UIColor(named: "MainPoint_mainColor")?.cgColor//UIColor(hexString: "#25E9AD").cgColor
//        textlayer.cornerRadius = 15
//        textlayer.contentsScale = UIScreen.main.scale
//        textlayer.convert(dotLayer.position, to: dotLayer)
//        circleView.layer.addSublayer(textlayer)
        
        if action == true{
            shapeLayer.strokeEnd = progress
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
        print("CircleProgressBar deinit")
    }
}

class ECATextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        let yDiff: CGFloat
        let fontSize: CGFloat
        let height = self.bounds.height

        if let attributedString = self.string as? NSAttributedString {
            fontSize = attributedString.size().height
            yDiff = (height-fontSize)/2
        } else {
            fontSize = self.fontSize
            yDiff = (height-fontSize)/2 - fontSize/10
        }

        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    deinit {
        print("ECATextLayer deinit")
    }
}
