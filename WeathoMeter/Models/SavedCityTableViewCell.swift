//
//  SavedCityTableViewCell.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//

import UIKit

class SavedCityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var humdity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
