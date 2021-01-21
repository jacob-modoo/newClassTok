//
//  HtmlToSwift.swift
//  enfit_swift
//
//  Created by 조현민 on 19/03/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import UIKit

//let htmlString = "Put Your YourHTML String Here"
//
//let setHeightUsingCSS = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.textView.frame.size.width) !important; width: auto; height: auto;} </style> </head><body> \(htmlString) </body>"


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    func convertToAttributedFromHTML() -> NSAttributedString? {
        var attributedText: NSAttributedString?
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            attributedText = attrStr
        }
        return attributedText
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


class YouTubeTextView: UITextView {

    
    private var formated_string : String!;
    private var encoded_text : Data!;
    private var attributed_text : NSAttributedString!;
    
    public func setText(text: String) {
        
        self.formated_string = formatString(text: text);
        
        self.encoded_text = self.formated_string.data(using: String.Encoding.utf8);
        
        if let attributedBody = try? NSAttributedString(data: encoded_text, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            
            self.attributed_text = attributedBody;
        } else {
            self.text = "";
        }
        
        if let attributed_text = self.attributed_text {
            self.attributedText = attributed_text;
        } else {
            print("error");
        }
        
    }
    
    //main function that adds the youtube frame
    func formatString(text: String) -> String {
        
        let iframe_texts = matches(for: ".*iframe.*", in: text);
        var new_text = text;
        if iframe_texts.count > 0 {
            for iframe_text in iframe_texts {
                let iframe_id = matches(for: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", in: iframe_text)
                
                let mutableStr = NSMutableString(string: iframe_text)
                let regex = try! NSRegularExpression(pattern: "<\\s*(iframe).+src=\"(.+?)\".+(/iframe)", options: [])
                let matches = regex.matches(in: iframe_text, options: [], range: NSMakeRange(0, mutableStr.length))

                var k = matches.count - 1
                while k  >= 0 {
                    let match = matches[k]
                    let components = mutableStr.substring(with: match.range(at: 2)).components(separatedBy: "/")
                    let newURL = "https://media.giphy.com/media/" + components.last! + "/giphy.gif"

                    mutableStr.replaceCharacters(in: match.range(at: 3), with: "/img")
                    mutableStr.replaceCharacters(in: match.range(at: 2), with: newURL)
                    mutableStr.replaceCharacters(in: match.range(at: 1), with: "img")

                    k -= 1
                }

                print(mutableStr as String)
                
                if iframe_id.count > 0 { //just in case there is another type of iframe
                    new_text = new_text.replacingOccurrences(of: iframe_text, with:"<a href='https://www.youtube.com/watch?v=\(iframe_id[0])'><img src=\"https://img.youtube.com/vi/" + iframe_id[0] + "/0.jpg\" alt=\"\" width=\"\(UIScreen.main.bounds.width - 24)\" /></a><p style='text-align: right'>YouTube.com</p>");
                }
            }
        } else {
            print("there is no iframe in this text");
        }
        return new_text;
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex,  options: .caseInsensitive)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

}
