//
//  DayViewCell.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var lbDate:UILabel
	@IBOutlet var lbDayName:UILabel
	@IBOutlet var lbWeekday:UILabel

	@IBOutlet var lbExtra:UILabel
	
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
	
	init(coder aDecoder: NSCoder!) {
		super.init(coder: aDecoder)
	}
}
