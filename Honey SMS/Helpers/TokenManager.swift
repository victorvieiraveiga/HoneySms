//
//  TokenManager.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 14/02/21.
//

import Foundation

public class TokenManager {
    
    let defaults = UserDefaults()
    
    func saveTokenUserDefauts(token: String) {
        self.defaults.setValue(token, forKey: "accessToken")
    }
    
    func getToken () -> String {
        guard let accessToken = self.defaults.string(forKey: "accessToken") else {return ""}
        
        return accessToken
    }
    
}
