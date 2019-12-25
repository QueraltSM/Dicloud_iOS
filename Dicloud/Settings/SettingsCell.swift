//
//  SettingsCell.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 5/12/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var settingOption: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
