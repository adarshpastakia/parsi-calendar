//
//  DayTableViewCell.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/12/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

	@IBOutlet var lbDate:UILabel!
	@IBOutlet var lbDayName:UILabel!
	@IBOutlet var lbWeekday:UILabel!

	@IBOutlet var lbExtra1:UILabel!
	@IBOutlet var lbExtra2:UILabel!
	@IBOutlet var lbExtraMore:UILabel!

	@IBOutlet var ivTodayTop:UIImageView!
	@IBOutlet var ivTodayBottom:UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
