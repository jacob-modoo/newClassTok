//
//  JsonToDictionary.swift
//  modooClass
//
//  Created by 조현민 on 17/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

// 하나만 오는거 반환
public func convertToDictionary(data:Data,apiURL:String) -> Dictionary<String, Any>! {
    //print("convertToDictionary")
    do {
        let resString = String(data: data, encoding: .utf8)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
        print("---------------------------------------------------------------------------------------------------------------------")
        print("**  \(apiURL)  **")
        print("\(resString ?? "")")
        print("---------------------------------------------------------------------------------------------------------------------")
        return json
    } catch {
        print("Something went wrong")
    }
    return nil
}
// 여러개 오는거 반환
public func convertToArray(data:Data,apiURL:String) -> Array<Any>! {
//    print("convertToDictionary")
    do {
        let resString = String(data: data, encoding: .utf8)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<Any>
        print("---------------------------------------------------------------------------------------------------------------------")
        print("**  \(apiURL)  **")
        print("\(resString ?? "")")
        print("---------------------------------------------------------------------------------------------------------------------")
        return json
    } catch {
        print("Something went wrong")
    }
    return nil
}
