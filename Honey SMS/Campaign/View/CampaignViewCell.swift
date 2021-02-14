//
//  CampaignViewCell.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 01/02/21.
//

import UIKit

class CampaignViewCell: UITableViewCell {


    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelType: UILabel!
   // @IBOutlet weak var labelLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func ConfigCell(campaign: [Campanha], indexpath: Int) {

        
        
        labelData.text = campaign[indexpath].date_dateFormated
        labelType.text = campaign[indexpath].nome
       // labelLocation.text = ""//campaign[indexpath].nome
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formataData (dataSelect : String) -> String{
        
        
        
                let dateFormatter = DateFormatter()
//                 let myString = (String(describing: data))
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                 let yourDate: Date? = dateFormatter.date(from: myString)
//                dateFormatter.dateFormat = "dd-MM-yyyy"
        
                //convert string to date
                dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let dateAux = dateFormatter.date(from:dataSelect) else { return "" }
        
                //Format date to brasilian pattern
                dateFormatter.dateFormat = "dd/MM/yyyy"
                return dateFormatter.string(from: dateAux)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let myString = formatter.string(from: data)
//        let yourDate: Date? = formatter.date(from: myString)
//        formatter.dateFormat = "dd-MMM-yyyy"
//        let updatedString = formatter.string(from: yourDate!)
//
//        return updatedString
    }

}
