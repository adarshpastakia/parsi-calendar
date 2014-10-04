//
//  BookmarkFormViewController.swift
//  parsi-calendar
//
//  Created by Adarsh Pastakia on 04/10/2014.
//  Copyright (c) 2014 Boris Inc. All rights reserved.
//

import UIKit

class BookmarkFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var formView:UIView?
    
    @IBOutlet var tfDay:UITextField?
    @IBOutlet var tfMonth:UITextField?
    @IBOutlet var tfBookmark:UITextField?
    
    @IBOutlet var pkDay:UIPickerView?
    @IBOutlet var pkMonth:UIPickerView?
    
    @IBOutlet var toolbar:UIToolbar?
    
    @IBOutlet var hCenter:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        formView?.layer.borderWidth = 0
        formView?.layer.borderColor = UIColor(hue:142.0/360.0, saturation:0.62, brightness:0.36, alpha:1.0).CGColor
        
        tfDay?.inputView = pkDay
        tfMonth?.inputView = pkMonth
        
        tfDay?.inputAccessoryView = toolbar
        tfMonth?.inputAccessoryView = toolbar
        tfBookmark?.inputAccessoryView = toolbar
        
        pkDay?.delegate = self
        pkDay?.dataSource = self
        
        pkMonth?.delegate = self
        pkMonth?.dataSource = self
        
        
        Helper.registerForKeybaordNotifications(self, onShow: Selector("keyboardWasShown:"), onHide: Selector("keyboardWasHidden:"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Call this method somewhere in your view controller setup code.
    func keyboardWasShown(notification:NSNotification) {
        let info = notification.userInfo as NSDictionary!
        let size = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        
        self.hCenter!.constant = (size.height - 40) / 2
    }
    
    func keyboardWasHidden(notification:NSNotification) {
        self.hCenter!.constant = 0
    }
    
    
    
    // MARK : Picker datasource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pkMonth {
            return 12
        }
        if pickerView == pkDay {
            return pkMonth?.selectedRowInComponent(0) == 11 ? 35 : 30
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pkMonth {
            return MonthNames.name(row)
        }
        if pickerView == pkDay {
            return DayNames.name(row)
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pkMonth {
            tfMonth?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
            if row != 11 && pkDay?.selectedRowInComponent(0) > 30 {
                pkDay?.selectRow(0, inComponent: 0, animated: false)
                tfDay?.text = ""
            }
        }
        if pickerView == pkDay {
            tfDay?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        }
    }
    
    
    // MARK: Actions
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!) -> Bool {
        return touch.view != formView
    }
    
    @IBAction func dismissKeyboard() {
        tfDay?.text = self.pickerView(pkDay!, titleForRow: pkDay!.selectedRowInComponent(0), forComponent: 0)
        tfMonth?.text = self.pickerView(pkMonth!, titleForRow: pkMonth!.selectedRowInComponent(0), forComponent: 0)
        
        tfDay?.resignFirstResponder()
        tfMonth?.resignFirstResponder()
        tfBookmark?.resignFirstResponder()
    }
    
    @IBAction func dismissView() {
        tfDay?.resignFirstResponder()
        tfMonth?.resignFirstResponder()
        tfBookmark?.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBookmark() {
        var valid = true
        let invalidColor = UIColor(hue:60.0/360.0, saturation:0.03, brightness:0.96, alpha:1.0)

        tfDay?.backgroundColor = UIColor.whiteColor()
        tfMonth?.backgroundColor = UIColor.whiteColor()
        tfBookmark?.backgroundColor = UIColor.whiteColor()

        if tfDay?.text == "" {
            valid = false
            tfDay?.backgroundColor = invalidColor
        }
        if tfMonth?.text == "" {
            valid = false
            tfMonth?.backgroundColor = invalidColor
        }
        if tfBookmark?.text == "" {
            valid = false
            tfBookmark?.backgroundColor = invalidColor
        }
        if !valid {
            Helper.vibrateView(formView!)
            return
        }
        BookmarkDay.insert(pkDay!.selectedRowInComponent(0), month: pkMonth!.selectedRowInComponent(0), title: tfBookmark!.text, isDefault: false)
        dismissView()
    }
}
