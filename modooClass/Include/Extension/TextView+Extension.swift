//
//  TextViewWhiteSpace.swift
//  modooClass
//
//  Created by 조현민 on 24/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

enum wordType {
    case hashtag
    case mention
}

extension NSAttributedString {
    
    //하얀 공백 제거
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        print(startLocation,"-----",endLocation)
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
    
}

import Foundation
@IBDesignable extension UITextView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
//        pulse.initialVelocity = 0.5
        pulse.initialVelocity = 1
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
    //텍스트뷰 더보기 시작
    /**
     Calls provided `test` block if point is in gliph range and there is no link detected at this point.
     Will pass in to `test` a character index that corresponds to `point`.
     Return `self` in `test` if text view should intercept the touch event or `nil` otherwise.
     */
    public func hitTest(pointInGliphRange aPoint: CGPoint, event: UIEvent?, test: (Int) -> UIView?) -> UIView? {
        guard let charIndex = charIndexForPointInGlyphRect(point: aPoint) else {
            return super.hitTest(aPoint, with: event)
        }
        guard textStorage.attribute(NSAttributedString.Key.link, at: charIndex, effectiveRange: nil) == nil else {
            return super.hitTest(aPoint, with: event)
        }
        return test(charIndex)
    }
    
    /**
     Returns true if point is in text bounding rect adjusted with padding.
     Bounding rect will be enlarged with positive padding values and decreased with negative values.
     */
    public func pointIsInTextRange(point aPoint: CGPoint, range: NSRange, padding: UIEdgeInsets) -> Bool {
        var boundingRect = layoutManager.boundingRectForCharacterRange(range: range, inTextContainer: textContainer)
        boundingRect = boundingRect.offsetBy(dx: textContainerInset.left, dy: textContainerInset.top)
        boundingRect = boundingRect.insetBy(dx: -(padding.left + padding.right), dy: -(padding.top + padding.bottom))
        return boundingRect.contains(aPoint)
    }
    
    /**
     Returns index of character for glyph at provided point. Returns `nil` if point is out of any glyph.
     */
    public func charIndexForPointInGlyphRect(point aPoint: CGPoint) -> Int? {
        let point = CGPoint(x: aPoint.x, y: aPoint.y - textContainerInset.top)
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSMakeRange(glyphIndex, 1), in: textContainer)
        if glyphRect.contains(point) {
            return layoutManager.characterIndexForGlyph(at: glyphIndex)
        } else {
            return nil
        }
    }
    //텍스트뷰 더보기 끝
}

extension NSLayoutManager {
    
    //텍스트뷰 더보기 시작
    /**
     Returns characters range that completely fits into container.
     */
    public func characterRangeThatFits(textContainer container: NSTextContainer) -> NSRange {
        var rangeThatFits = self.glyphRange(for: container)
        rangeThatFits = self.characterRange(forGlyphRange: rangeThatFits, actualGlyphRange: nil)
        return rangeThatFits
    }
    
    /**
     Returns bounding rect in provided container for characters in provided range.
     */
    public func boundingRectForCharacterRange(range aRange: NSRange, inTextContainer container: NSTextContainer) -> CGRect {
        let glyphRange = self.glyphRange(forCharacterRange: aRange, actualCharacterRange: nil)
        let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: container)
        return boundingRect
    }
    //텍스트뷰 더보기 끝
    
}

//MARK: - detecting hashtags and mentions and making them clickable

class AttrTextView: UITextView {
    var textString: NSString?
    var attrString: NSMutableAttributedString?
    var callBack: ((String, wordType)-> Void)?
    
    public func setText(text: String, mentionColor: UIColor, callBack: @escaping(String, wordType)->Void, normalFont: UIFont, mentionFont: UIFont, nameTapped:Bool) {
        self.callBack = callBack
        self.attrString = NSMutableAttributedString(string: text)
        self.textString = NSString(string: text)
        
//        Set initial font attributes for our string
        attrString?.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSRange(location: 0, length: textString?.length ?? 0))
        attrString?.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#484848"), range: NSRange(location: 0, length: textString?.length ?? 0))
        
//        Call a custom set Hashtag and Mention attributes function
        if nameTapped != false {
//            setAttrWithName(attrName: "Hashtag", wordPrefix: "#", color: hashtagColor, text: text, font: hashTagFont)
            setAttrWithName(attrName: "Mention", wordPrefix: "@", color: mentionColor, text: text, font: mentionFont)
        }
        
//        Add tap geesture that calls a function tapRecognized when tapped
        let tapper = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(tapGesture:)))
        addGestureRecognizer(tapper)
    }
    
    private func setAttrWithName(attrName: String, wordPrefix: String, color: UIColor, text: String, font: UIFont) {
//        Words can be separated by either a space or a line break
        var words = text.components(separatedBy: " ")
        words.append(contentsOf: text.components(separatedBy: " "))
        
//        Filter to check for the # or @ prefix
        for word in words.filter({$0.hasPrefix(wordPrefix)}) {
            let range = textString!.range(of: word)
            attrString?.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            attrString?.addAttribute(NSAttributedString.Key(rawValue: attrName), value: 1, range: range)
            attrString?.addAttribute(NSAttributedString.Key(rawValue: "Clickable"), value: 1, range: range)
            attrString?.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            
        }
        self.attributedText = attrString
    }
    
    @objc func tapRecognized(tapGesture: UITapGestureRecognizer) {
        var wordString: String?
        var char: NSAttributedString?
        var word: NSAttributedString?
        var isHashtag: AnyObject?
        var isMention: AnyObject?
        
//        Gets the range of the character at the place the user taps
        let point = tapGesture.location(in: self)
        let charPosition = closestPosition(to: point)
        let charRange = tokenizer.rangeEnclosingPosition(charPosition!, with: .character, inDirection: UITextDirection(rawValue: 1))
        
//        Checks if the user has tapped on a character
        if charRange != nil {
            let location = offset(from: beginningOfDocument, to: charRange!.start)
            let length = offset(from: charRange!.start, to: charRange!.end)
            let attrRange = NSMakeRange(location, length)
            char = attributedText.attributedSubstring(from: attrRange)
            
//            If the user does not click on anything, exit the function
            if !text.contains("@") {
                print("User clicked on nothing : \(char?.string ?? "")")
                return
            }
            
            isHashtag = char?.attribute(NSAttributedString.Key(rawValue: "Hashtag"), at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, char!.length)) as AnyObject?
            isMention = char?.attribute(NSAttributedString.Key(rawValue: "Mention"), at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, char!.length)) as AnyObject?
        }
        
//        Gets the range of the word at the place user taps
        let wordRange = tokenizer.rangeEnclosingPosition(charPosition!, with: .word, inDirection: UITextDirection(rawValue: 1))
        
        if wordRange != nil {
            let wordLocation = offset(from: beginningOfDocument, to: wordRange!.start)
            let wordLength = offset(from: wordRange!.start, to: wordRange!.end)
            let wordAttrRange = NSMakeRange(wordLocation, wordLength)
            word = attributedText.attributedSubstring(from: wordAttrRange)
            wordString = word!.string
        } else {
            var modifiedPoint = point
            modifiedPoint.x += 12
            let modifiedPosition = closestPosition(to: modifiedPoint)
            let modifiedWordRange = tokenizer.rangeEnclosingPosition(modifiedPosition!, with: .word, inDirection: UITextDirection(rawValue: 1))
            if modifiedWordRange != nil {
                let wordLocation = offset(from: beginningOfDocument, to: modifiedWordRange!.start)
                let wordLength = offset(from: modifiedWordRange!.start, to: modifiedWordRange!.end)
                let wordAttrRange = NSMakeRange(wordLocation, wordLength)
                word = attributedText.attributedSubstring(from: wordAttrRange)
                wordString = word!.string
            }
        }
        
        if let stringToPass = wordString {
            if isHashtag != nil && callBack != nil {
                callBack!(stringToPass, wordType.hashtag)
            } else if isMention != nil && callBack != nil {
                callBack!(stringToPass, wordType.mention)
            }
        }
    }
    
}
