//
//  ViewController.swift
//  TipCalculator
//
//  Created by Juliang Li on 12/2/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var tipSlider: UISlider!
    @IBOutlet var tipPercentageLabel: UILabel!
    @IBOutlet var tipAmountLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var tipSegments: UISegmentedControl!
    var settings:SettingView!
    let userData = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        amountTextField.keyboardType = UIKeyboardType.DecimalPad
        amountTextField.textAlignment = NSTextAlignment.Right
        amountTextField.becomeFirstResponder()
        settings = NSBundle.mainBundle().loadNibNamed("SettingView", owner: self, options: nil).last as! SettingView
        settings.frame = CGRectMake(0, -self.view.frame.size.height + 40, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(settings)
        settings.setup()
        self.setup()
    }
    func setup(){
        //restore the default tip
        let defaultTip:Int = userData.integerForKey("tip")
        let segmentIndex:Int = (defaultTip - 10) / 5
        tipSegments.selectedSegmentIndex = segmentIndex
        tipSegments.sendAction("tipSegmentsValueChanged:", to: self, forEvent: nil)
        //restore old amount
        if let previousDate = userData.objectForKey("time") as? NSDate{
            let elapsedTime = Int(NSDate().timeIntervalSinceDate(previousDate))
            if elapsedTime <= 3600{
                if let amount = userData.objectForKey("amount") as? String{
                    amountTextField.text = amount
                }
            }
        }
        calculateTips()
        
    }
    func saveUserData(){
        userData.setObject(amountTextField.text, forKey: "amount")
        userData.setObject(NSDate(), forKey: "time")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateTips(){
        // do the calculation
        let amount:Double = (amountTextField.text! as NSString).doubleValue
        let percentage:Double = (tipPercentageLabel.text! as NSString).doubleValue
        let tip:Double = amount * percentage / 100
        tipAmountLabel.text = "$ " + String(format:"%.2f", tip)
        let total:Double = (amountTextField.text! as NSString).doubleValue + tip
        totalLabel.text = "$ " + String(format:"%.2f",total)
    }
    @IBAction func amountEditing(sender: UITextField) {
        // make sure the dot only appears at most once
        var dotCount:Int = 0
        var text = Array(amountTextField.text!.characters)
        var lastDotIndex = 0;
        for (var i = 0; i < text.count; ++i){
            if (text[i] == "."){
                dotCount += 1
                lastDotIndex = i;
            }
        }
        if (dotCount > 1){
            amountTextField.text!.removeAtIndex(amountTextField.text!.startIndex.advancedBy(lastDotIndex))
            return
        }
        self.calculateTips()
        self.saveUserData()
    }
    
    @IBAction func tipSliderValueChanged(sender: UISlider) {
        let value:Int = Int(tipSlider.value)
        tipPercentageLabel.text = String(value) + "%";
        // unselect the tip segment to avoid confusion
        tipSegments.selectedSegmentIndex = -1
        self.calculateTips()
        
    }
    @IBAction func tipSegmentsValueChanged(sender: UISegmentedControl) {
        let index:Int = tipSegments.selectedSegmentIndex
        // minimal tip is 10% and increment by 5%
        let value:Int = 10 + 5 * index
        tipSlider.setValue(Float(value), animated: true)
        tipSlider.sendAction("tipSliderValueChanged:", to: self, forEvent: nil)
        // select the tip segment
        tipSegments.selectedSegmentIndex = index
    }

}

