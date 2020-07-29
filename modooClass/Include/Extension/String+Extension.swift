//
//  SubString.swift
//  modooClass
//
//  Created by 조현민 on 20/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import CommonCrypto

// SubString (글자열 자르기)

extension String {
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
            else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }
    
    func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.utf16Offset(in: String(c))//encodedOffset
    }
    
}
extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

/*
 let text = "www.stackoverflow.com"
 let at = text.character(3) // .
 let range = text.substring(0..<3) // www
 let from = text.substring(from: 4) // stackoverflow.com
 let to = text.substring(to: 16) // www.stackoverflow
 let between = text.between(".", ".") // stackoverflow
 let substringToLastIndexOfChar = text.lastIndexOfCharacter(".") // 17
 */

// 정규식

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){
                
                if(self.count>=6 && self.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    var isPhoneNumber: Bool {
        do {
            
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                if(self.count == 11){
                    let str = self.substring(to: 2)
                    if str == "010"{
                        return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
                    }else{
                        return false
                    }
                }else{
                    return false
                }
                
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    //    func isValidPhone(phone: String) -> Bool {
    //
    //        let phoneRegex = "^[0-9]{6,14}$";
    //        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    //        return valid
    //    }
    //
    //    func isValidEmail(candidate: String) -> Bool {
    //
    //        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    //        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    //        if valid {
    //            valid = !candidate.contains("..")
    //        }
    //        return valid
    //    }
}

extension String {
    public func separate(withChar char : String) -> [String]{
        var word : String = ""
        var words : [String] = [String]()
        for chararacter in self {
            if String(chararacter) == char && word != "" {
                words.append(word)
                word = char
            }else {
                word += String(chararacter)
            }
        }
        words.append(word)
        return words
    }

}

extension String {
    func md5() ->   String {
        let data = Data(utf8) as NSData
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
