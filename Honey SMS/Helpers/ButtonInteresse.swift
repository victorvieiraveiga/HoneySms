//
//  ButtonInteresse.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 18/03/21.
//

import Foundation
import UIKit

class ButtonInteresse : UIButton {

    var idLead : String = ""
    var interesse: Int = 0
    var token: String = ""

    convenience init(idLead: String, interesse: Int, token: String) {
        self.init()
        self.idLead = idLead
    }
}
