//
//  CampaignModel.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 01/02/21.
//

import Foundation

struct CampaignModel: Codable {
    var success : Bool
    var data : [Campanha]
}

struct Campanha : Codable {
    var id : String
    var nome: String
    var dataExecucao : String
    
   var date_dateFormated: String {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: dataExecucao)

        guard dateFormatter.date(from: dataExecucao) != nil else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "dd/MM/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        print(timeStamp)
        return timeStamp
    }
}


