//
//  UIFixedLabel.swift
//  modooClass
//
//  Created by 조현민 on 14/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//
import UIKit
import Foundation
import QuartzCore

class UIFixedLabel:UILabel{

    enum LabelType:Int{
        case Point = 1
        case MainTitle = 2
        case SubTitle = 3
        case MainHead = 4
        case SubHead = 5
        case MainBody = 6
        case SubBody = 7
        case Discription = 8
    }

    enum LabelFontWeight:Int{
        case Regular = 1
        case Bold = 2
    }

    enum LabelColor:Int {
        case mainPoint_mainColor = 1
        case mainPoint_subColor1 = 2
        case mainPoint_subColor2 = 3
        case mainPoint_subColor3 = 4
        case mainPoint_subColor4 = 5
        case fontColor_mainColor = 11
        case fontColor_subColor1 = 12
        case fontColor_subColor2 = 13
        case fontColor_subColor3 = 14
    }

    var labelType:LabelType? = .MainBody
    var fontWeight:LabelFontWeight? = .Regular
    var color:LabelColor? = .mainPoint_mainColor

    @IBInspectable var typeAdapter:Int {
        get {
            return self.labelType!.rawValue
        }
        set( typeIndex) {
            self.labelType = LabelType(rawValue: typeIndex) ?? .MainBody
        }
    }
    
    @IBInspectable var fontAdapter:Int {
        get {
            return self.fontWeight!.rawValue
        }
        set( fontIndex) {
            
            self.fontWeight = LabelFontWeight(rawValue: fontIndex) ?? .Regular
            
            switch  fontWeight {
            case .Regular:
                self.font = UIFont(name: "AppleSDGothicNeo-Regular", size: labelFontSize())
            case .Bold:
                self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: labelFontSize())
            case .none:
                self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: labelFontSize())
            }
        }
    }
    
    func labelFontSize() -> CGFloat{
        switch  labelType {
        case .Point:
            return 27
        case .MainTitle:
            return 22
        case .SubTitle:
            return 20
        case .MainHead:
            return 18
        case .SubHead:
            return 16
        case .MainBody:
            return 14
        case .SubBody:
            return 12.5
        case .Discription:
            return 11
        case .none:
            return 17
        }
    }
    
    @IBInspectable var colorAdapter:Int {
        get {
            return self.color!.rawValue
        }
        set( colorIndex) {
            
            self.color = LabelColor(rawValue: colorIndex) ?? .mainPoint_mainColor
            
            switch  color {
            case .mainPoint_mainColor:
                self.textColor = UIColor(named: "MainPoint_mainColor")
            case .mainPoint_subColor1:
                self.textColor = UIColor(named: "MainPoint_subColor1")
            case .mainPoint_subColor2:
                self.textColor = UIColor(named: "MainPoint_subColor2")
            case .mainPoint_subColor3:
                self.textColor = UIColor(named: "MainPoint_subColor3")
            case .mainPoint_subColor4:
                self.textColor = UIColor(named: "MainPoint_subColor4")
            case .fontColor_mainColor:
                self.textColor = UIColor(named: "FontColor_mainColor")
            case .fontColor_subColor1:
                self.textColor = UIColor(named: "FontColor_subColor1")
            case .fontColor_subColor2:
                self.textColor = UIColor(named: "FontColor_subColor2")
            case .fontColor_subColor3:
                self.textColor = UIColor(named: "FontColor_subColor3")
            case .none:
                self.textColor = UIColor(hexString: "#ffffff")
            }
        }
    }
    
    deinit {
        // perform the deinitialization
    }
}

class UIFixedTextField:UITextField{

    enum TextFieldType:Int{
        case Point = 1
        case MainTitle = 2
        case SubTitle = 3
        case MainHead = 4
        case SubHead = 5
        case MainBody = 6
        case SubBody = 7
        case Discription = 8
    }

    enum TextFieldFontWeight:Int{
        case Regular = 1
        case Bold = 2
    }

    enum TextFieldColor:Int {
        case mainPoint_mainColor = 1
        case mainPoint_subColor1 = 2
        case mainPoint_subColor2 = 3
        case mainPoint_subColor3 = 4
        case mainPoint_subColor4 = 5
        case fontColor_mainColor = 11
        case fontColor_subColor1 = 12
        case fontColor_subColor2 = 13
        case fontColor_subColor3 = 14
    }

    var textFieldType:TextFieldType? = .MainBody
    var fontWeight:TextFieldFontWeight? = .Regular
    var color:TextFieldColor? = .mainPoint_mainColor

    @IBInspectable var typeAdapter:Int {
        get {
            return self.textFieldType!.rawValue
        }
        set( typeIndex) {
            self.textFieldType = TextFieldType(rawValue: typeIndex) ?? .MainBody
        }
    }
    
    @IBInspectable var fontAdapter:Int {
        get {
            return self.fontWeight!.rawValue
        }
        set( fontIndex) {
            
            self.fontWeight = TextFieldFontWeight(rawValue: fontIndex) ?? .Regular
            
            switch  fontWeight {
            case .Regular:
                self.font = UIFont(name: "AppleSDGothicNeo-Regular", size: labelFontSize())
            case .Bold:
                self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: labelFontSize())
            case .none:
                self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: labelFontSize())
            }
        }
    }
    
    func labelFontSize() -> CGFloat{
        switch  textFieldType {
        case .Point:
            return 27
        case .MainTitle:
            return 22
        case .SubTitle:
            return 20
        case .MainHead:
            return 18
        case .SubHead:
            return 16
        case .MainBody:
            return 14
        case .SubBody:
            return 12.5
        case .Discription:
            return 11
        case .none:
            return 17
        }
    }
    
    @IBInspectable var colorAdapter:Int {
        get {
            return self.color!.rawValue
        }
        set( colorIndex) {
            
            self.color = TextFieldColor(rawValue: colorIndex) ?? .mainPoint_mainColor
            
            switch  color {
            case .mainPoint_mainColor:
                self.textColor = UIColor(named: "MainPoint_mainColor")
            case .mainPoint_subColor1:
                self.textColor = UIColor(named: "MainPoint_subColor1")
            case .mainPoint_subColor2:
                self.textColor = UIColor(named: "MainPoint_subColor2")
            case .mainPoint_subColor3:
                self.textColor = UIColor(named: "MainPoint_subColor3")
            case .mainPoint_subColor4:
                self.textColor = UIColor(named: "MainPoint_subColor4")
            case .fontColor_mainColor:
                self.textColor = UIColor(named: "FontColor_mainColor")
            case .fontColor_subColor1:
                self.textColor = UIColor(named: "FontColor_subColor1")
            case .fontColor_subColor2:
                self.textColor = UIColor(named: "FontColor_subColor2")
            case .fontColor_subColor3:
                self.textColor = UIColor(named: "FontColor_subColor3")
            case .none:
                self.textColor = UIColor(hexString: "#ffffff")
            }
        }
    }
    deinit {
        // perform the deinitialization
    }
}

class UIFixedTextView:UITextView{

    enum TextViewType:Int{
        case Point = 1
        case MainTitle = 2
        case SubTitle = 3
        case MainHead = 4
        case SubHead = 5
        case MainBody = 6
        case SubBody = 7
        case Discription = 8
    }

    enum TextViewFontWeight:Int{
        case Regular = 1
        case Bold = 2
    }

    enum TextViewColor:Int {
        case mainPoint_mainColor = 1
        case mainPoint_subColor1 = 2
        case mainPoint_subColor2 = 3
        case mainPoint_subColor3 = 4
        case mainPoint_subColor4 = 5
        case fontColor_mainColor = 11
        case fontColor_subColor1 = 12
        case fontColor_subColor2 = 13
        case fontColor_subColor3 = 14
    }

    var textViewType:TextViewType? = .MainBody
    var fontWeight:TextViewFontWeight? = .Regular
    var color:TextViewColor? = .mainPoint_mainColor

    @IBInspectable var typeAdapter:Int {
        get {
            return self.textViewType!.rawValue
        }
        set( typeIndex) {
            self.textViewType = TextViewType(rawValue: typeIndex) ?? .MainBody
        }
    }
    
    @IBInspectable var fontAdapter:Int {
        get {
            return self.fontWeight!.rawValue
        }
        set( fontIndex) {
            
            self.fontWeight = TextViewFontWeight(rawValue: fontIndex) ?? .Regular
            
            switch  fontWeight {
            case .Regular:
                self.font = UIFont(name: "AppleSDGothicNeo-Regular", size: textViewFontSize())
            case .Bold:
                self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: textViewFontSize())
            case .none:
                self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: textViewFontSize())
            }
        }
    }
    
    func textViewFontSize() -> CGFloat{
        switch textViewType {
        case .Point:
            return 27
        case .MainTitle:
            return 22
        case .SubTitle:
            return 20
        case .MainHead:
            return 18
        case .SubHead:
            return 16
        case .MainBody:
            return 14
        case .SubBody:
            return 12.5
        case .Discription:
            return 11
        case .none:
            return 17
        }
    }
    
    @IBInspectable var colorAdapter:Int {
        get {
            return self.color!.rawValue
        }
        set( colorIndex) {
            
            self.color = TextViewColor(rawValue: colorIndex) ?? .mainPoint_mainColor
            
            switch  color {
            case .mainPoint_mainColor:
                self.textColor = UIColor(named: "MainPoint_mainColor") //1
            case .mainPoint_subColor1:
                self.textColor = UIColor(named: "MainPoint_subColor1") //2
            case .mainPoint_subColor2:
                self.textColor = UIColor(named: "MainPoint_subColor2") //3
            case .mainPoint_subColor3:
                self.textColor = UIColor(named: "MainPoint_subColor3") //4
            case .mainPoint_subColor4:
                self.textColor = UIColor(named: "MainPoint_subColor4") //5
            case .fontColor_mainColor:
                self.textColor = UIColor(named: "FontColor_mainColor") // 11
            case .fontColor_subColor1:
                self.textColor = UIColor(named: "FontColor_subColor1") // 12
            case .fontColor_subColor2:
                self.textColor = UIColor(named: "FontColor_subColor2") // 13
            case .fontColor_subColor3:
                self.textColor = UIColor(named: "FontColor_subColor3") //14
            case .none:
                self.textColor = UIColor(hexString: "#ffffff")
            }
        }
    }
    deinit {
        // perform the deinitialization
    }
}

class UIFixedButton:UIButton{

    enum ButtonTextType:Int{
        case Point = 1
        case MainTitle = 2
        case SubTitle = 3
        case MainHead = 4
        case SubHead = 5
        case MainBody = 6
        case SubBody = 7
        case Discription = 8
    }

    enum ButtonFontWeight:Int{
        case Regular = 1
        case Bold = 2
    }

    enum ButtonColor:Int {
        case mainPoint_mainColor = 1
        case mainPoint_subColor1 = 2
        case mainPoint_subColor2 = 3
        case mainPoint_subColor3 = 4
        case mainPoint_subColor4 = 5
        case fontColor_mainColor = 11
        case fontColor_subColor1 = 12
        case fontColor_subColor2 = 13
        case fontColor_subColor3 = 14
        case buttonColor_textColor1 = 21
        case buttonColor_textColor2 = 22
    }
    
    enum ButtonBackColor:Int{
        case buttonColorType1 = 1
        case buttonColorType2 = 2
    }

    var buttonTextType:ButtonTextType? = .MainBody
    var fontWeight:ButtonFontWeight? = .Regular
    var color:ButtonColor? = .mainPoint_mainColor
    var backColor:ButtonBackColor? = .buttonColorType1

    @IBInspectable var typeAdapter:Int {
        get {
            return self.buttonTextType!.rawValue
        }
        set( typeIndex) {
            self.buttonTextType = ButtonTextType(rawValue: typeIndex) ?? .MainBody
        }
    }
    
    @IBInspectable var fontAdapter:Int {
        get {
            return self.fontWeight!.rawValue
        }
        set( fontIndex) {
            
            self.fontWeight = ButtonFontWeight(rawValue: fontIndex) ?? .Regular
            
            switch  fontWeight {
            case .Regular:
                self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: buttonFontSize())
            case .Bold:
                self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: buttonFontSize())
            case .none:
                self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: buttonFontSize())
            }
        }
    }
    
    func buttonFontSize() -> CGFloat{
        switch  buttonTextType {
        case .Point:
            return 27
        case .MainTitle:
            return 22
        case .SubTitle:
            return 20
        case .MainHead:
            return 18
        case .SubHead:
            return 16
        case .MainBody:
            return 14
        case .SubBody:
            return 12.5
        case .Discription:
            return 11
        case .none:
            return 17
        }
    }
    
    @IBInspectable var colorAdapter:Int {
        get {
            return self.color!.rawValue
        }
        set( colorIndex) {
            
            self.color = ButtonColor(rawValue: colorIndex) ?? .mainPoint_mainColor
            
            switch  color {
            case .mainPoint_mainColor:
                self.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
            case .mainPoint_subColor1:
                self.setTitleColor(UIColor(named: "MainPoint_subColor1"), for: .normal)
            case .mainPoint_subColor2:
                self.setTitleColor(UIColor(named: "MainPoint_subColor2"), for: .normal)
            case .mainPoint_subColor3:
                self.setTitleColor(UIColor(named: "MainPoint_subColor3"), for: .normal)
            case .mainPoint_subColor4:
                self.setTitleColor(UIColor(named: "MainPoint_subColor4"), for: .normal)
            case .fontColor_mainColor:
                self.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
            case .fontColor_subColor1:
                self.setTitleColor(UIColor(named: "FontColor_subColor1"), for: .normal)
            case .fontColor_subColor2:
                self.setTitleColor(UIColor(named: "FontColor_subColor2"), for: .normal)
            case .fontColor_subColor3:
                self.setTitleColor(UIColor(named: "FontColor_subColor3"), for: .normal)
            case .buttonColor_textColor1:
                self.setTitleColor(UIColor(named: "ButtonTextColor1"), for: .normal)
            case .buttonColor_textColor2:
                self.setTitleColor(UIColor(named: "ButtonTextColor2"), for: .normal)
            case .none:
                self.setTitleColor(UIColor(hexString: "#ffffff"), for: .normal)
            }
        }
    }
    
    @IBInspectable var backColorAdapter:Int {
        get {
            return self.backColor!.rawValue
        }
        set( colorIndex) {
            
            self.backColor = ButtonBackColor(rawValue: colorIndex) ?? .buttonColorType1
            
            switch backColor {
            case .buttonColorType1:
                self.backgroundColor = UIColor(named: "ButtonBackColor1")
            case .buttonColorType2:
                self.backgroundColor = UIColor(named: "ButtonBackColor2")
            case .none:
                self.backgroundColor = UIColor(hexString: "#ffffff")
            }
        }
    }
    deinit {
        // perform the deinitialization
    }
//    Button Effect
//    @IBInspectable open var ripplePercent: Float = 1.0 {
//        didSet {
//            setupRippleView()
//        }
//    }
//    
//    @IBInspectable open var rippleColor: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(247/255.0), blue: CGFloat(247/255.0), alpha: CGFloat(0.5) ){
//        didSet {
//            rippleView.backgroundColor = rippleColor
//        }
//    }
//    
//    @IBInspectable open var rippleBackgroundColor: UIColor = UIColor(white: 0.95, alpha: 0) {
//        didSet {
//            rippleBackgroundView.backgroundColor = rippleBackgroundColor
//        }
//    }
//    
//    @IBInspectable open var buttonCornerRadius: Float = 0 {
//        didSet{
////            layer.cornerRadius = CGFloat(buttonCornerRadius)
//        }
//    }
//    
//    @IBInspectable open var rippleOverBounds: Bool = false
//    @IBInspectable open var shadowRippleRadius: Float = 1
//    @IBInspectable open var shadowRippleEnable: Bool = true
//    @IBInspectable open var trackTouchLocation: Bool = false
//    @IBInspectable open var touchUpAnimationTime: Double = 0.3
//    
//    let rippleView = UIView()
//    let rippleBackgroundView = UIView()
//    
//    fileprivate var tempShadowRadius: CGFloat = 0
//    fileprivate var tempShadowOpacity: Float = 0
//    fileprivate var touchCenterLocation: CGPoint?
//    
//    fileprivate var rippleMask: CAShapeLayer? {
//        get {
//            if !rippleOverBounds {
//                let maskLayer = CAShapeLayer()
//                maskLayer.path = UIBezierPath(roundedRect: bounds,
//                    cornerRadius: layer.cornerRadius).cgPath
//                return maskLayer
//            } else {
//                return nil
//            }
//        }
//    }
//    
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    fileprivate func setup() {
//        setupRippleView()
//        
//        rippleBackgroundView.backgroundColor = rippleBackgroundColor
//        rippleBackgroundView.frame = bounds
//        rippleBackgroundView.addSubview(rippleView)
//        rippleBackgroundView.alpha = 0
//        addSubview(rippleBackgroundView)
//        
//        layer.shadowRadius = 0
//        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowColor = UIColor(white: 0.0, alpha: 0.2).cgColor
//    }
//    
//    fileprivate func setupRippleView() {
//        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
//        let x: CGFloat = (bounds.width/2) - (size/2)
//        let y: CGFloat = (bounds.height/2) - (size/2)
////        let corner: CGFloat = size/2
//        
//        rippleView.backgroundColor = rippleColor
//        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
//        rippleView.layer.cornerRadius = self.layer.cornerRadius//10//corner
//    }
//    
//    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        if trackTouchLocation {
//            touchCenterLocation = touch.location(in: self)
//        } else {
//            touchCenterLocation = nil
//        }
//        
//        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
//            self.rippleBackgroundView.alpha = 1
//            }, completion: nil)
//        
//        rippleView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        
//        
//        UIView.animate(withDuration: 0.3, delay: 0, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction],
//            animations: {
//                self.rippleView.transform = CGAffineTransform.identity
//            }, completion: nil)
//        
//        if shadowRippleEnable {
//            tempShadowRadius = layer.shadowRadius
//            tempShadowOpacity = layer.shadowOpacity
//            
//            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
//            shadowAnim.toValue = shadowRippleRadius
//            
//            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
//            opacityAnim.toValue = 1
//            
//            let groupAnim = CAAnimationGroup()
//            groupAnim.duration = 0.3
//            groupAnim.fillMode = CAMediaTimingFillMode.forwards
//            groupAnim.isRemovedOnCompletion = false
//            groupAnim.animations = [shadowAnim, opacityAnim]
//            
//            layer.add(groupAnim, forKey:"shadow")
//        }
//        return super.beginTracking(touch, with: event)
//    }
//    
//    override open func cancelTracking(with event: UIEvent?) {
//        super.cancelTracking(with: event)
//        animateToNormal()
//    }
//    
//    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        super.endTracking(touch, with: event)
//        animateToNormal()
//    }
//    
//    fileprivate func animateToNormal() {
//        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
//            self.rippleBackgroundView.alpha = 1
//            }, completion: {(success: Bool) -> () in
//                UIView.animate(withDuration: self.touchUpAnimationTime, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
//                    self.rippleBackgroundView.alpha = 0
//                    }, completion: nil)
//        })
//        
//        
//        UIView.animate(withDuration: 0.3, delay: 0,
//            options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
//            animations: {
//                self.rippleView.transform = CGAffineTransform.identity
//                
//                let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
//                shadowAnim.toValue = self.tempShadowRadius
//                
//                let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
//                opacityAnim.toValue = self.tempShadowOpacity
//                
//                let groupAnim = CAAnimationGroup()
//                groupAnim.duration = 0.3
//                groupAnim.fillMode = CAMediaTimingFillMode.forwards
//                groupAnim.isRemovedOnCompletion = false
//                groupAnim.animations = [shadowAnim, opacityAnim]
//                
//                self.layer.add(groupAnim, forKey:"shadowBack")
//            }, completion: nil)
//    }
//    
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        
//        setupRippleView()
//        if let knownTouchCenterLocation = touchCenterLocation {
//            rippleView.center = knownTouchCenterLocation
//        }
//        
//        rippleBackgroundView.layer.frame = bounds
//        rippleBackgroundView.layer.mask = rippleMask
//    }
    
}
