//
//  LeadsTableViewCell.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 04/02/21.
//

import UIKit

class LeadsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell (leads: [Leads], indexPath: Int) {
        
        labelName.text = leads[indexPath].nome
        labelPhone.text = leads[indexPath].PhoneFormated
        
    }

}
