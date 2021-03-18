//
//  ConvertToData.swift
//  modooClass
//
//  Created by 조현민 on 12/09/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

public func DictionaryToString(dic:Dictionary<String, Any>,strName:String) -> String{
    if let str = dic[strName] as? String {
        return str
    }else{
        print("------- 캐스팅 오류 ------- String \(strName)")
        return ""
    }
}

public func DictionaryToInt(dic:Dictionary<String, Any>,intName:String) -> Int{
    if let num = dic[intName] as? Int {
        return num
    }else{
        print("------- 캐스팅 오류 ------- Int \(intName)")
        return 0
    }
}

public func DictionaryToFloat(dic:Dictionary<String, Any>,floatName:String) -> Float{
    if let num = dic[floatName] as? Float {
        return num
    }else{
        print("------- 캐스팅 오류 ------- Float \(floatName)")
        return 0
    }
}

public func DictionaryToDouble(dic:Dictionary<String, Any>,doubleName:String) -> Double{
    if let num = dic[doubleName] as? Double {
        return num
    }else{
        print("------- 캐스팅 오류 ------- Double \(doubleName)")
        return 0
    }
}

public func DictionaryToBool(dic:Dictionary<String, Any>,boolName:String) -> Bool{
    if let bool = dic[boolName] as? Bool {
        return bool
    }else{
        print("------- 캐스팅 오류 ------- Bool \(boolName)")
        return false
    }
}

public func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("\(error)")
        }
    }
    return nil
}
