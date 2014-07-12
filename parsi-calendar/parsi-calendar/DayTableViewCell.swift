//
//  DayTableViewCell.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/12/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

	@IBOutlet var lbDate:UILabel
	@IBOutlet var lbDayName:UILabel
	@IBOutlet var lbWeekday:UILabel
	@IBOutlet var lbExtra:UILabel
	
	@IBOutlet var ivTodayTop:UIImageView
	@IBOutlet var ivTodayBottom:UIImageView
	
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
