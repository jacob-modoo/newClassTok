//
//  Facebook.swift
//  modooClass
//
//  Created by 조현민 on 07/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//


import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
//import FacebookCore
//import FacebookLogin
//import FBSDKLoginKit

class FaceBook{
    func facebookLogout(){
        LoginManager().logOut()
    }
    
    func facebookLogin(viewController:UIViewController){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .userFriends], viewController: viewController) { result in
            switch result {
            case .cancelled:
                print("Login Cancelled")
            case .failed(let error):
                print("Login Fail \(error)")
            case .success(let grantedPermissions, _, _):
                print("Login Success \(grantedPermissions)")
            }
        }
    }
    
    func checkRequestFacebook()-> Bool{
        return (AccessToken.current) != nil
    }
    
    func facebookInfoGet () -> (id:String,email:String,name:String){
        
        var facebookEmail:String = ""
        var facebookId:String = ""
        var facebookName:String = ""
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            let facetuple = FaceBook().facebookInfoCompletionHandler(connection, result as Any, error)
            print(facetuple.id)
            facebookEmail = facetuple.email
            facebookId = facetuple.id
            facebookName = facetuple.name
        })
        return (facebookId,facebookEmail,facebookName)
    }
    
    func facebookInfoCompletionHandler(_ connection: GraphRequestConnection?, _ result: Any, _ error: Error?) -> (id:String,email:String,name:String) {
        
        var facebookEmail:String = ""
        var facebookId:String = ""
        var facebookName:String = ""
        
        if (error == nil){
            let dict = result as! [String : AnyObject]
            //print(result!)
            print(dict)
            facebookEmail = dict["email"] as! String
            facebookId = dict["id"] as! String
            facebookName = dict["name"] as! String
            //            print("[LoginModule] email = \(facebookEmail)")
            //            print("[LoginModule] id = \(facebookId)")
            //            print("[LoginModule] name = \(name)")
        }
        return (facebookId,facebookEmail,facebookName)
    }
}
