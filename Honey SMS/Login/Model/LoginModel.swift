//
//  LoginModel.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 02/02/21.
//

import Foundation

struct LoginModel {
    
    var success : Bool
    var accessToken: String
    var user : String 
    
    func getToken() ->String {
        return accessToken
    }
}



//struct DataAccess : Codable{
//    let accessToken : String
//    let expiresIn : Int
//    let userToken : UserToken
//}
//
//struct UserToken : Codable {
//    let id : String
//    let email: String
//    let claims : [Claims]
//}
//
//struct Claims : Codable {
//    let value : String
//    let type :  String
//}


