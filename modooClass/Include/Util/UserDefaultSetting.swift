//
//  UserDefaultSetting.swift
//  modooClass
//
//  Created by 조현민 on 07/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class UserDefaultSetting: NSObject {
    class func getUserDefaultsObject(forKey defaultName: String?) -> Any? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.string(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsString(forKey defaultName: String?) -> Any? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.value(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsDictionary(forKey defaultName: String?) -> [AnyHashable : Any]? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.dictionary(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsStringArray(forKey defaultName: String?) -> [Any]? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.array(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsInteger(forKey defaultName: String?) -> Int {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.integer(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsFloat(forKey defaultName: String?) -> Float {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.float(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsDouble(forKey defaultName: String?) -> Double {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.double(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsBool(forKey defaultName: String?) -> Bool {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.bool(forKey: defaultName ?? "")
    }
    
    class func getUserDefaultsURL(forKey defaultName: String?) -> URL? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.url(forKey: defaultName ?? "")
    }
    
    // NSUserDefaults object, key값으로 저장하기
    class func setUserDefaultsObject(_ object: Any?, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(object, forKey: defaultName ?? "")
    }
    
    class func setUserDefaultsString(_ value: String, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName ?? "")
    }
    
    class func setUserDefaultsInteger(_ value: Int, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName ?? "")
    }
    
    class func setUserDefaultsFloat(_ value: Float, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName ?? "")
    }
    
    class func setUserDefaultsDouble(_ value: Double, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName ?? "")
    }
    
    class func setUserDefaultsBool(_ value: Bool, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName ?? "")
    }
    
    class func setUserDefaultsURL(_ url: URL?, forKey defaultName: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(url, forKey: defaultName ?? "")
    }
    
    // NSUserDefaults 전체 제거
    class func removeallUserDefaults() {
        let userDefaults = UserDefaults.standard
        
        let dicUuserDefaults = userDefaults.dictionaryRepresentation()
        for key: Any in dicUuserDefaults {
            userDefaults.removeObject(forKey: key as? String ?? "")
        }
        
        userDefaults.synchronize()
    }
}
