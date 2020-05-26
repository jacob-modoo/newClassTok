//
//  INAppPurchase.swift
//  modooClass
//
//  Created by 조현민 on 16/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchase : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let sharedInstance = InAppPurchase()
    var class_id:Int = 0
    var package_id:Int = 0
    
    let verifySandBoxReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
    
    let kInAppProductPurchasedNotification = "InAppProductPurchasedNotification"
    let kInAppPurchaseFailedNotification   = "InAppPurchaseFailedNotification"
    let kInAppProductRestoredNotification  = "InAppProductRestoredNotification"
    let kInAppPurchasingErrorNotification  = "InAppPurchasingErrorNotification"
    
    let unlockTestInAppPurchase1ProductId = "4900_won_modoo_test"
//    let unlockTestInAppPurchase2ProductId = "com.modooclass.iap2"
//    let autorenewableSubscriptionProductId = "com.testing.autorenewablesubscription"
//    let nonrenewingSubscriptionProductId = "com.testing.nonrenewingsubscription"
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func buyProduct(_ product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restoreTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error %@ \(error)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "purchasedCancle"), object: 2)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: error.localizedDescription)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Got the request from Apple")
        let count: Int = response.products.count
        if count > 0 {
            _ = response.products
            let validProduct: SKProduct = response.products[0]
            print(validProduct.localizedTitle)
            print(validProduct.localizedDescription)
            print(validProduct.price)
            buyProduct(validProduct);
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "purchasedCancle"), object: 3)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
            print("No products")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple");
        
        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    
                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductPurchasedNotification), object: nil)
                    receiptValidation()
                    break
                    
                case .failed:
                    print("Purchased Failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchaseFailedNotification), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "purchasedCancle"), object: 4)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
                    break
                    
                case .restored:
                    print("Product Restored")
                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductRestoredNotification), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "purchasedCancle"), object: 4)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
                    break
                    
                default:
                    break
                }
            }
            else {
                
            }
        }
    }
    
    func savePurchasedProductIdentifier(_ productIdentifier: String!) {
        UserDefaults.standard.set(productIdentifier, forKey: productIdentifier)
        UserDefaults.standard.synchronize()
    }
    
    func receiptValidation() {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject]//, "password" : "dab3f8e770384d99ae7dda0096529a30" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    print("jsonResponse : ",jsonResponse)
                    let status = jsonResponse["status"] as? Int
                    if status == 0{
                        FeedApi.shared.class_purchase(mcClass_id: self!.class_id, mcPackage_id: self!.package_id, user_id: UserManager.shared.userInfo.results?.user?.id ?? 0, iap_return: "\(jsonResponse)", success: { result in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadWebViewCheck"), object: result.results?.return_url ?? "")
                            
                        }) { error in
                            
                        }
                    }else if status == 21007{
                        print("이 영수증은 테스트 환경에서 제공되었지만 검증을 위해 프로덕션 환경으로 전송되었습니다. 대신 테스트 환경으로 보내십시오.")
                        self!.receiptSendBoxValidation()
                    }else if status == 21000{
                        print("json객체가 잘못되었습니다.")
                    }else if status == 21002{
                        print("receipt-data속성 의 데이터 가 잘못되었거나 누락되었습니다.")
                    }else if status == 21003{
                        print("영수증 인증 불가")
                    }else if status == 21004{
                        print("제공 한 공유 비밀번호가 계정의 파일에있는 공유 비밀번호와 일치하지 않습니다.")
                    }else if status == 21005{
                        print("영수증 서버를 현재 사용할 수 없습니다.")
                    }else if status == 21006{
                        print("이 영수증은 유효하지만 구독이 만료되었습니다. 이 상태 코드가 서버로 반환되면 영수증 데이터도 디코딩되어 응답의 일부로 반환됩니다. 자동 갱신 구독의 iOS 6 스타일 거래 영수증에 대해서만 반환됩니다.")
                    }else if status == 21008{
                        print("이 영수증은 프로덕션 환경에서 제공되었지만 검증을 위해 테스트 환경으로 전송되었습니다. 대신 프로덕션 환경으로 보내십시오.")
                    }else if status == 21010{
                        print("이 영수증을 승인 할 수 없습니다. 구매 한 적이없는 것처럼 취급하십시오.")
                    }else{
                        print("내부 데이터 엑세스 오류")
                    }
                    
                    
                    if let date = self?.getExpirationDateFromResponse(jsonResponse as NSDictionary) {
                        print(date)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
                } catch let parseError {
                    print(parseError)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
                }
            })
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
            task.resume()
        } catch let parseError {
            print(parseError)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
        }
    }
    
    func receiptSendBoxValidation(){
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject]//, "password" : "dab3f8e770384d99ae7dda0096529a30" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifySandBoxReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    print("jsonResponse : ",jsonResponse)
                    
                    let status = jsonResponse["status"] as? Int
                    
                    if status == 0{
                        print("이 영수증은 테스트 환경에서 잘 제공되었습니다.")
                        FeedApi.shared.class_purchase(mcClass_id: self!.class_id, mcPackage_id: self!.package_id, user_id: UserManager.shared.userInfo.results?.user?.id ?? 0, iap_return: "\(jsonResponse)", success: { result in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadWebViewCheck"), object: result.results?.return_url ?? "")
                        }) { error in
                            
                        }
                    }else if status == 21007{
                        print("이 영수증은 테스트 환경에서 제공되었지만 검증을 위해 프로덕션 환경으로 전송되었습니다. 대신 테스트 환경으로 보내십시오.")
                    }else if status == 21000{
                        print("json객체가 잘못되었습니다.")
                    }else if status == 21002{
                        print("receipt-data속성 의 데이터 가 잘못되었거나 누락되었습니다.")
                    }else if status == 21003{
                        print("영수증 인증 불가")
                    }else if status == 21004{
                        print("제공 한 공유 비밀번호가 계정의 파일에있는 공유 비밀번호와 일치하지 않습니다.")
                    }else if status == 21005{
                        print("영수증 서버를 현재 사용할 수 없습니다.")
                    }else if status == 21006{
                        print("이 영수증은 유효하지만 구독이 만료되었습니다. 이 상태 코드가 서버로 반환되면 영수증 데이터도 디코딩되어 응답의 일부로 반환됩니다. 자동 갱신 구독의 iOS 6 스타일 거래 영수증에 대해서만 반환됩니다.")
                    }else if status == 21008{
                        self!.receiptValidation()
                        print("이 영수증은 프로덕션 환경에서 제공되었지만 검증을 위해 테스트 환경으로 전송되었습니다. 대신 프로덕션 환경으로 보내십시오.")
                    }else if status == 21010{
                        print("이 영수증을 승인 할 수 없습니다. 구매 한 적이없는 것처럼 취급하십시오.")
                    }else{
                        print("내부 데이터 엑세스 오류")
                    }
                    
                    if let date = self?.getExpirationDateFromResponse(jsonResponse as NSDictionary) {
                        print(date)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
                } catch let parseError {
                    print(parseError)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
                }
            })
            task.resume()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
        } catch let parseError {
            print(parseError)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {

            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
    
    func unlockProduct(_ productIdentifier: String!) {
        if SKPaymentQueue.canMakePayments() {
            
            let productID: NSSet = NSSet(object: productIdentifier!)
            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
            print("Fetching Products")
        }
        else {
            print("Сan't make purchases")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "purchasedCancle"), object: 1)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: NSLocalizedString("CANT_MAKE_PURCHASES", comment: "Can't make purchases"))
        }
    }
    
    func buyUnlockTestInAppPurchase1(productId:String,class_id:Int,package_id:Int) {
        unlockProduct(productId)
//        unlockProduct(unlockTestInAppPurchase1ProductId)
        self.class_id = class_id
        self.package_id = package_id
    }
    
//    func buyUnlockTestInAppPurchase2() {
//        unlockProduct(unlockTestInAppPurchase2ProductId)
//    }
//
//    func buyAutorenewableSubscription() {
//        unlockProduct(autorenewableSubscriptionProductId)
//    }
//    
//    func buyNonrenewingSubscription() {
//        unlockProduct(nonrenewingSubscriptionProductId)
//    }
    
}
