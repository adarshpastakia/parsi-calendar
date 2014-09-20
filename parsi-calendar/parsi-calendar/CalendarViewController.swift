//
//  CalendarViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 7/11/14.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet var tableView:UITableView!
	@IBOutlet var collectionView:UICollectionView!
	
	var currentViewDate = NSDate()
	var firstDate = NSDate()
	
	var df = NSDateFormatter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Do any additional setup after loading the view.
		today(nil)
	}
	
	override func viewDidAppear(animated: Bool) {
		if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
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
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func configureView() {
		var day = Calendar.getParsiDay(currentViewDate)
		firstDate = currentViewDate.dateByAddingTimeInterval(Double(day)*Double(-1*24*60*60))
		var month = Calendar.getParsiMonth(firstDate)
		
 		self.navigationItem.title = "\(MonthNames.name(month)) \(Calendar.yearLabel(Calendar.getParsiYear(firstDate)))"
		
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
	
	func getDate(indexPath:NSIndexPath) -> NSDate {
		var dayNo = indexPath.row
		
		if indexPath.section == 1 {
			dayNo = indexPath.row + getSectionItems(0)
		}
		
		return  firstDate.dateByAddingTimeInterval(Double(dayNo) * 24*60*60) as NSDate
	}
	
	// #pragma mark UICollectionViewDataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return getSectionItems(section)
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as DayCollectionViewCell
		
		var dt:NSDate = getDate(indexPath)
		
		cell.backgroundColor = UIColor.whiteColor()
		cell.layer.cornerRadius = 4
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
		cell.lbDayName.text = " \(DayNames.name(day))"
		
		if weekday == 1 {
			cell.lbDate.textColor = Colors.weekendColor
			cell.lbWeekday.textColor = UIColor.whiteColor()
			cell.lbWeekday.backgroundColor = Colors.weekendColor
		}
		if Calendar.isSpecialDay(dt) {
			cell.lbDayName.textColor = UIColor.whiteColor()
			cell.lbDayName.backgroundColor = Colors.importantDay
		}
		if day >= 30 {
			cell.lbDayName.textColor = UIColor.whiteColor()
			cell.lbDayName.backgroundColor = Colors.gathaDay
		}
		
		if dt.isToday() {
			cell.backgroundColor = Colors.today
			cell.layer.borderWidth = 1
			cell.layer.borderColor = Colors.todayBorder.CGColor
		}
		
		cell.lbExtra1.text = ""
		cell.lbExtra2.text = ""
		cell.lbExtraMore.text = ""
		if let extras = Calendar.getDayExtraForCell(dt) {
			if extras.count > 0 { cell.lbExtra1.text = extras[0] }
			if extras.count > 1 { cell.lbExtra2.text = extras[1] }
			if extras.count > 2 { cell.lbExtraMore.text = extras[2] }
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		var view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "MonthHeader", forIndexPath: indexPath) as UICollectionReusableView
		
		var lb = view.viewWithTag(1) as UILabel
		
		df.dateFormat = "MMMM yyyy"
		lb.text = getSectionTitle(indexPath.section)
		
		return view
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var dt:NSDate = getDate(indexPath)
		let extras = Calendar.getDayExtraForAlert(dt)
		if !extras.isEmpty {
			var day:Int = Calendar.getParsiDay(dt)
			var month:Int = Calendar.getParsiMonth(dt)
			df.dateFormat = "dd MMM yyyy"
			var date = df.stringFromDate(dt)
			Helper.showAlert("\(DayNames.name(day)), \(MonthNames.name(month))", msg: "\(date)\n\n\(extras)")
		}
	}
	
	
	// #pragma mark - Table data source
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return getSectionItems(section)
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return "  \(getSectionTitle(section))"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath) as DayTableViewCell
		
		var dt:NSDate = getDate(indexPath)
		
		cell.backgroundColor = UIColor.whiteColor()
		
		df.dateFormat = "dd"
		cell.lbDate.text = df.stringFromDate(dt)
		df.dateFormat = "EEE"
		cell.lbWeekday.text = df.stringFromDate(dt)
		
		var day:Int = Calendar.getParsiDay(dt)
		cell.lbDayName.text = " \(DayNames.name(day))"
		
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
		if Calendar.isSpecialDay(dt) {
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
		
		cell.lbExtra1.text = ""
		cell.lbExtra2.text = ""
		cell.lbExtraMore.text = ""
		if let extras = Calendar.getDayExtraForCell(dt) {
			if extras.count > 0 { cell.lbExtra1.text = extras[0] }
			if extras.count > 1 { cell.lbExtra2.text = extras[1] }
			if extras.count > 2 { cell.lbExtraMore.text = extras[2] }
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var dt:NSDate = getDate(indexPath)
		let extras = Calendar.getDayExtraForAlert(dt)
		if !extras.isEmpty {
			var day:Int = Calendar.getParsiDay(dt)
			var month:Int = Calendar.getParsiMonth(dt)
			df.dateFormat = "dd MMM yyyy"
			var date = df.stringFromDate(dt)
			Helper.showAlert("\(DayNames.name(day)), \(MonthNames.name(month))", msg: "\(date)\n\n\(extras)")
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
