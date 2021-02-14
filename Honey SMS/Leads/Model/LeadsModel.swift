//
//  LeadsModel.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 03/02/21.
//

import Foundation

struct LeadsModel : Codable {
    var success : Bool
    var data : [Leads]
    

}

struct Leads : Codable {
    var id : String
    var nome : String
    var telefone: String
    var interesse : Int
    
    var PhoneFormated: String {
                                                                      //55 (21) 98556-9475
        let formattedText = telefone.applyPatternOnNumbers(pattern: "+## (##) ####-#####", replacmentCharacter: "#")
        return formattedText
    }
}
