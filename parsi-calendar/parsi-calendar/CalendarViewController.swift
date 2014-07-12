//
//  CalendarViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet var tableView:UITableView
	@IBOutlet var collectionView:UICollectionView
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		// Custom initialization
	}
	
	init(coder aDecoder: NSCoder!) {
		super.init(coder: aDecoder)
	}
	
	var currentViewDate = NSDate()
	var firstDate = NSDate()
	
	var df = NSDateFormatter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Do any additional setup after loading the view.
	}
	
	override func viewDidAppear(animated: Bool) {
		today(nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func configureView() {
		var day = Calendar.getParsiDay(currentViewDate)
		firstDate = currentViewDate.dateByAddingTimeInterval(Double(day)*Double(-1*24*60*60))
		var month = Calendar.getParsiMonth(firstDate)
		
		self.navigationItem.title = "\(MonthNames.en[month]) \(Calendar.getParsiYear(firstDate))"
		
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			collectionView.reloadData()
		}
		else {
			tableView.reloadData()
			if currentViewDate.isToday() {
				var day = Calendar.getParsiDay(NSDate())
				var indexPath = NSIndexPath(forRow: day, inSection: 0)
				if day > getSectionItems(0) {
					day = day - getSectionItems(0)
					indexPath = NSIndexPath(forRow: day, inSection: 1)
				}
				tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
			}
			else {
				tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
			}
		}
	}
	
	func getSectionItems(section:Int) -> Int {
		var fdComp = firstDate.components()
		var ndComp = firstDate.components()
		ndComp.month++
		ndComp.day = 1
		var month = Calendar.getParsiMonth(currentViewDate)
		
		var x = NSDate.fromComponents(ndComp).timeIntervalSinceDate(NSDate.fromComponents(fdComp))
		
		if section == 1 && month == 11 {
			return Int(35 - floor(x/(24*60*60)))
		}
		
		return section == 0 ? Int(floor(x/(24*60*60))) : Int(30 - floor(x/(24*60*60)))
	}
	
	func getSectionTitle(section:Int) -> String {
		df.dateFormat = "MMMM yyyy"
		
		if section == 1 {
			var ndComp = firstDate.components()
			ndComp.month++
			ndComp.day = 1
			return df.stringFromDate(NSDate.fromComponents(ndComp))
		}
		return df.stringFromDate(firstDate)
	}
	
	func getDayExtra(dt:NSDate) -> String {
		if Calendar.getParsiMonth(dt) == 0 && Calendar.getParsiDay(dt) == 0 {
			return "Navroz"
		}
		if Calendar.getParsiMonth(dt) == 0 && Calendar.getParsiDay(dt) == 5 {
			return "Khordad Saal"
		}
		if dt.on(NSDate.fromComponents(21, month: 3, year: dt.components().year)) {
			return "Jamedshji Navroz"
		}
		
		return ""
	}
	
	// #pragma mark UICollectionViewDataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView?) -> Int {
		return 2
	}
	
	
	func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
		return getSectionItems(section)
	}
	
	func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath?) -> UICollectionViewCell? {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as DayCollectionViewCell
		
		var dayNo = indexPath!.row
		
		if indexPath!.section == 1 {
			dayNo = indexPath!.row + getSectionItems(0)
		}
		var dt:NSDate = firstDate.addTimeInterval(Double(dayNo) * 24*60*60) as NSDate
		
		cell.backgroundColor = UIColor.whiteColor()
		cell.layer.cornerRadius = 8
		cell.layer.borderWidth = 1
		cell.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
		
		df.dateFormat = "dd"
		cell.lbDate.text = df.stringFromDate(dt)
		df.dateFormat = "EEE"
		cell.lbWeekday.text = df.stringFromDate(dt)
		
		let weekday = dt.components().weekday
		
		cell.lbDate.textColor = UIColor.blackColor()
		cell.lbWeekday.textColor = UIColor.darkGrayColor()
		cell.lbWeekday.backgroundColor = UIColor.clearColor()
		cell.lbDayName.textColor = UIColor.darkGrayColor()
		cell.lbDayName.backgroundColor = UIColor.clearColor()
		
		cell.lbWeekday.layer.cornerRadius = 4
		cell.lbDayName.layer.cornerRadius = 4
		
		var day:Int = Calendar.getParsiDay(dt)
		cell.lbDayName.text = " \(DayNames.en[day])"
		
		if weekday == 1 {
			cell.lbDate.textColor = Colors.weekendColor
			cell.lbWeekday.textColor = UIColor.whiteColor()
			cell.lbWeekday.backgroundColor = Colors.weekendColor
		}
		if Dates.impDays.bridgeToObjectiveC().containsObject(day) {
			cell.lbDayName.textColor = UIColor.whiteColor()
			cell.lbDayName.backgroundColor = Colors.importantDay
		}
		if day >= 30 {
			cell.lbDayName.textColor = UIColor.whiteColor()
			cell.lbDayName.backgroundColor = Colors.gathaDay
		}
		
		if dt.isToday() {
			cell.backgroundColor = Colors.today
			cell.layer.borderWidth = 2
			cell.layer.borderColor = Colors.todayBorder.CGColor
		}
		
		cell.lbExtra.text = getDayExtra(dt)
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
		
		var view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "MonthHeader", forIndexPath: indexPath) as UICollectionReusableView
		
		var lb = view.viewWithTag(1) as UILabel
		
		df.dateFormat = "MMMM yyyy"
		lb.text = getSectionTitle(indexPath.section)
		
		return view
	}
	
	
	// #pragma mark - Table data source
	func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return getSectionItems(section)
	}
	
	func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
		return "  \(getSectionTitle(section))"
	}
	
	func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
		let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath) as DayTableViewCell
		
		var dt:NSDate = firstDate.addTimeInterval(Double(indexPath!.row) * 24*60*60) as NSDate
		
		if indexPath!.section == 1 {
			dt = firstDate.addTimeInterval(Double(indexPath!.row + getSectionItems(0)) * 24*60*60) as NSDate
		}
		
		cell.backgroundColor = UIColor.whiteColor()
		
		df.dateFormat = "dd"
		cell.lbDate.text = df.stringFromDate(dt)
		df.dateFormat = "EEE"
		cell.lbWeekday.text = df.stringFromDate(dt)
		
		var day:Int = Calendar.getParsiDay(dt)
		cell.lbDayName.text = " \(DayNames.en[day])"
		
		let weekday = dt.components().weekday
		
		cell.lbDate.textColor = UIColor.blackColor()
		cell.lbWeekday.textColor = UIColor.darkGrayColor()
		cell.lbWeekday.backgroundColor = UIColor.clearColor()
		cell.lbDayName.textColor = UIColor.darkGrayColor()
		cell.lbDayName.backgroundColor = UIColor.clearColor()
		
		cell.lbWeekday.layer.cornerRadius = 4
		cell.lbDayName.layer.cornerRadius = 4
		
		cell.ivTodayTop.hidden = true
		cell.ivTodayBottom.hidden = true
		
		if weekday == 1 {
			cell.lbDate.textColor = Colors.weekendColor
			cell.lbWeekday.textColor = UIColor.whiteColor()
			cell.lbWeekday.backgroundColor = Colors.weekendColor
		}
		if Dates.impDays.bridgeToObjectiveC().containsObject(day) {
			cell.lbDayName.textColor = UIColor.whiteColor()
			cell.lbDayName.backgroundColor = Colors.importantDay
		}
		if day >= 30 {
			cell.lbDayName.textColor = UIColor.whiteColor()
			cell.lbDayName.backgroundColor = Colors.gathaDay
		}
		
		if dt.isToday() {
			cell.backgroundColor = Colors.today
			
			cell.ivTodayTop.hidden = false
			cell.ivTodayBottom.hidden = false
		}
		
		cell.lbExtra.text = getDayExtra(dt)
		
		return cell
	}
	
	// #pragma mark - actions
	@IBAction func nextMonth(sender:AnyObject!) {
		currentViewDate = currentViewDate.dateByAddingTimeInterval(30*24*60*60)
		if Calendar.getParsiMonth(currentViewDate) == 11 {
			currentViewDate = currentViewDate.dateByAddingTimeInterval(5*24*60*60)
		}
		configureView()
	}
	@IBAction func prevMonth(sender:AnyObject!) {
		currentViewDate = currentViewDate.dateByAddingTimeInterval(-30*24*60*60)
		if Calendar.getParsiMonth(currentViewDate) == 11 {
			currentViewDate = currentViewDate.dateByAddingTimeInterval(-5*24*60*60)
		}
		configureView()
	}
	@IBAction func today(sender:AnyObject!) {
		currentViewDate = NSDate()
		configureView()
	}
}
