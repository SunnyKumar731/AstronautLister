//
//  AstronautListTableViewCell.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import UIKit
import SDWebImage

class AstronautListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
   
    func configure(astronautDataModel: AstronautListDataModel) {
        imgView.sd_setImage(with: URL(string: astronautDataModel.profileImageUrl), placeholderImage: UIImage(named: "icons_load"))
        nameLabel.text = String(format: "%@:  %@", Utility.localisedStringfor(key: "name"), astronautDataModel.name)
        nationalityLabel.text = String(format: "%@:  %@",Utility.localisedStringfor(key: "nationality"), astronautDataModel.nationality)
    }
}
