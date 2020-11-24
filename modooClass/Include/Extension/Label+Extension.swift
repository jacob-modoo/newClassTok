//
//  Label+Extension.swift
//  modooClass
//
//  Created by 조현민 on 15/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
@IBDesignable extension UILabel {
    
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
}


extension UILabel {
    var isTruncatedText: Bool {
        guard let height = textHeight else {
            return false
        }
        return height > bounds.size.height
    }
    
    var textHeight: CGFloat? {
        guard let labelText = text else {
            return nil
        }
        let attributes: [NSAttributedString.Key: UIFont] = [.font: font]
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).size
        return ceil(labelTextSize.height)
    }
    
    @discardableResult
    func setExpandActionIfPossible(_ text: String, textColor: UIColor? = nil) -> NSRange? {
        guard isTruncatedText, let visibleString = visibleText else {
            return nil
        }
        let defaultTruncatedString = "... "
        let fontAttribute: [NSAttributedString.Key: UIFont] = [.font: font]
        let expandAttributedString: NSMutableAttributedString = NSMutableAttributedString(
            string: defaultTruncatedString,
            attributes: fontAttribute
        )
        let customExpandAttributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: (textColor ?? self.textColor) as Any
        ]
        let customExpandAttributedString = NSAttributedString(string: "\(text)", attributes: customExpandAttributes)
        expandAttributedString.append(customExpandAttributedString)
        
        let visibleAttributedString = NSMutableAttributedString(string: visibleString, attributes: fontAttribute)
        guard visibleAttributedString.length > expandAttributedString.length else {
            return nil
        }
        let changeRange = NSRange(location: visibleAttributedString.length - expandAttributedString.length, length: expandAttributedString.length)
        visibleAttributedString.replaceCharacters(in: changeRange, with: expandAttributedString)
        attributedText = visibleAttributedString
        return changeRange
    }
    
    var visibleText: String? {
        guard isTruncatedText,
            let labelText = text,
            let lastIndex = truncationIndex else {
            return nil
        }
        let visibleTextRange = NSRange(location: 0, length: lastIndex)
        guard let range = Range(visibleTextRange, in: labelText) else {
            return nil
        }
        return String(labelText[range])
    }
    
    //https://stackoverflow.com/questions/41628215/uitextview-find-location-of-ellipsis-in-truncated-text/63797174#63797174
    var truncationIndex: Int? {
        guard let text = text, isTruncatedText else {
            return nil
        }
        let attributes: [NSAttributedString.Key: UIFont] = [.font: font]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textContainer = NSTextContainer(
            size: CGSize(width: frame.size.width,
                         height: CGFloat.greatestFiniteMagnitude)
        )
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: attributedString)
        textStorage.addLayoutManager(layoutManager)

        //Determine the range of all Glpyhs within the string
        var glyphRange = NSRange()
        layoutManager.glyphRange(
            forCharacterRange: NSMakeRange(0, attributedString.length),
            actualCharacterRange: &glyphRange
        )

        var truncationIndex = NSNotFound
        //Iterate over each 'line fragment' (each line as it's presented, according to your `textContainer.lineBreakMode`)
        var i = 0
        layoutManager.enumerateLineFragments(
            forGlyphRange: glyphRange
        ) { rect, usedRect, textContainer, glyphRange, stop in
            if (i == self.numberOfLines - 1) {
                //We're now looking at the last visible line (the one at which text will be truncated)
                let lineFragmentTruncatedGlyphIndex = glyphRange.location
                if lineFragmentTruncatedGlyphIndex != NSNotFound {
                    truncationIndex = layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: lineFragmentTruncatedGlyphIndex).location
                }
                stop.pointee = true
            }
            i += 1
        }
        return truncationIndex
    }
    
    //https://stackoverflow.com/questions/1256887/create-tap-able-links-in-the-nsattributedstring-of-a-uilabel
    private func getIndex(from point: CGPoint) -> Int? {
        guard let attributedString = attributedText, attributedString.length > 0 else {
            return nil
        }
        let textStorage = NSTextStorage(attributedString: attributedString)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        return index
    }
    
    func didTapInRange(_ point: CGPoint, targetRange: NSRange) -> Bool {
        guard let indexOfPoint = getIndex(from: point) else {
            return false
        }
        return indexOfPoint > targetRange.location &&
            indexOfPoint < targetRange.location + targetRange.length
    }
}
