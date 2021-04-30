//
//  CustomTableViewCell.swift
//  Weather
//
//  Created by Rahul's MacBook Pro on 29/04/21.
//  Copyright © 2021 Rahul M. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cityTitle: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
