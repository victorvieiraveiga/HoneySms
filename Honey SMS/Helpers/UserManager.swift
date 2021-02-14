//
//  UserManager.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 14/02/21.
//

import Foundation

public class UserManager {
    let defaults = UserDefaults()
    
    func saveUserAndPassword (_ user: String, _ password: String) {
        
        
        defaults.set(user, forKey: "user")
        defaults.set(password, forKey: "password")
    }
    
    func getUser () -> String {
        
        let user = defaults.string(forKey: "user") as! String
        
        return user
        
    }
    
    func getUserAndPassword () -> NSDictionary {
        let user = defaults.string(forKey: "user") as! String
        let password = defaults.string(forKey: "password") as! String
        
        let dic : NSDictionary?
         
        dic = [ "user" : user,
                "password": password]
        
        return dic!
        
    }
    
    
}
