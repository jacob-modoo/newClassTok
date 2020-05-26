//
//  KeychainItem.swift
//  modooClass
//
//  Created by 조현민 on 24/09/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

struct KeychainItem {
    // MARK: Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    // MARK: Properties
    
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?
    
    // MARK: Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    
    func readItem() throws -> String {
        
        /*
             서비스, ​​계정 및 서비스와 일치하는 항목을 찾기위한 쿼리 작성
             액세스 그룹.
        */
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // 쿼리와 일치하는 기존 키 체인 항목을 가져 오십시오.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // 반환 상태를 확인하고 적절한 경우 오류를 발생시킵니다.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // 쿼리 결과에서 비밀번호 문자열을 구문 분석합니다.
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func saveItem(_ password: String) throws {
        // 암호를 Data 객체로 인코딩합니다.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // 키 체인에서 기존 항목을 확인합니다.
            try _ = readItem()
            
            // 기존 비밀번호를 새 비밀번호로 업데이트합니다.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // 예기치 않은 상태가 반환되면 오류를 발생시킵니다.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            /*
             키 체인에 비밀번호가 없습니다. 새로운 키 체인 항목으로 저장할 사전을 만듭니다.
             */
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // 키 체인에 새 항목을 추가하십시오.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // 예기치 않은 상태가 반환되면 오류를 발생시킵니다.
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func deleteItem() throws {
        // 키 체인에서 기존 항목을 삭제하십시오.
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // 예기치 않은 상태가 반환되면 오류를 발생시킵니다.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    /*
     이 데모 앱의 목적 상 사용자 식별자는 장치 키 체인에 저장됩니다.
     계정 관리 시스템에 사용자 식별자를 저장해야합니다.
     */
    static var currentUserIdentifier: String {
        do {
            let storedIdentifier = try KeychainItem(service: "kr.co.enfit.modooClass", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return ""
        }
    }
    
    static func deleteUserIdentifierFromKeychain() {
        do {
            try KeychainItem(service: "kr.co.enfit.modooClass", account: "userIdentifier").deleteItem()
        } catch {
            print("Unable to delete userIdentifier from keychain")
        }
    }
}
