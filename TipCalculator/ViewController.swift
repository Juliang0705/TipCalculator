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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        amountTextField.keyboardType = UIKeyboardType.NumberPad
        amountTextField.textAlignment = NSTextAlignment.Right
        amountTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func amountEditing(sender: UITextField) {
        var number:String = sender.text
        var length:Int = (number as NSString).length
        switch length{
            case 0:
                number = "0.00"
            case 1:
                number = "0.0" + number
          //  case 2:
          //      number = "0." + number
            default:
                number.removeAtIndex(advance(number.endIndex,-2))
                number.insert(".", atIndex: advance(number.endIndex,-2))
        }
        sender.text = number
    }
    @IBAction func tipSliderValueChanged(sender: UISlider) {
        let value:Int = Int(sender.value)
        tipPercentageLabel.text = String(value) + "%";
    }
    @IBAction func tipSegmentsValueChanged(sender: UISegmentedControl) {
        let index:Int = sender.selectedSegmentIndex
        // minimal tip is 10% and increment by 5%
        let value:Int = 10 + 5 * index
        tipSlider.setValue(Float(value), animated: true)
        tipSlider.sendAction("tipSliderValueChanged:", to: self, forEvent: nil)
    }
    


}

