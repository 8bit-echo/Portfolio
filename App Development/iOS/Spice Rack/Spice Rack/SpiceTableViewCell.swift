//
//  SpiceTableViewCell.swift
//  Spice Rack
//
//  Created by Matt Dickey on 4/10/16.
//  Copyright © 2016 Matt Dickey. All rights reserved.
//

import UIKit

class SpiceTableViewCell: UITableViewCell {

    @IBOutlet weak var customTextLabel: UILabel!
    @IBOutlet weak var customDetailTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
