//
//  ViewController.swift
//  TipCalculator
//
//  Created by Phạm Thanh Hùng on 5/28/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var facesView: UIView!

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var localeControl: UISegmentedControl!
    
    @IBOutlet weak var leftFace: UIImageView!
    @IBOutlet weak var middleFace: UIImageView!
    @IBOutlet weak var rightFace: UIImageView!
    
    var faces: [UIImageView] {
        return [leftFace, middleFace, rightFace]
    }
    
    let selectedFaceAlpha   = CGFloat(1.0)
    let deselectedFaceAlpha = CGFloat(0.10)
    
    let defaultTipAmount = 0.2
    let availableLocales = [
        Locale(identifier: "en_US"),
        Locale(identifier: "en_UK"),
        Locale(identifier: "vi_VN")
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        billField.becomeFirstResponder()
        
        updateFaces()
        updateLocale()
        updateDefaultTipValues()
        updateToPreviousTotal()
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View will appear")
        updateLocale()
        updateDefaultTipValues()
        
        updateTheme()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func onEditingChanged(_ sender: Any) {
        updateFaces()
        
        if let billAmount = billAsDouble() {
            updateTip(billAmount)
        } else {
            print("TODO: handle invalid value")
        }
        
        var userPreferences = UserPreferences()
        userPreferences.preferredLocale = localeControl.selectedSegmentIndex
        userPreferences.save()
    }
    
    func updateTip(_ billAmount: Double) {
        let tip   = billAmount * tipPercentage()
        let total = billAmount + tip
        
        tipLabel.text   = formatCurrency(tip)
        totalLabel.text = formatCurrency(total)
        
        var userPreferences = UserPreferences()
        userPreferences.previousBill = billAmount
        userPreferences.save()
    }
    
    func updateFaces() {
        UIView.animate(withDuration: 0.75, animations: {
            for (index, face) in self.faces.enumerated() {
                if self.tipControl.selectedSegmentIndex == index {
                    face.alpha = self.selectedFaceAlpha
                } else {
                    face.alpha = self.deselectedFaceAlpha
                }
            }
        })
    }
    
    func updateDefaultTipValues() {
        let userPreferences = UserPreferences()
        
        for (index, defaultTipAmount) in userPreferences.defaultTipPercentages().enumerated() {
            tipControl.setTitle(String(defaultTipAmount) + "%", forSegmentAt: index)
        }
    }
    
    func updateLocale() {
        let userPreferences = UserPreferences()
        localeControl.selectedSegmentIndex = userPreferences.preferredLocale
        
        localeControl.sendActions(for: UIControlEvents.valueChanged)
    }
    
    func updateTheme() {
        let userPreferences = UserPreferences()
        
        let newColor = userPreferences.defaultColor
        changeColorTheme(newColor: newColor)
    }
    
    func changeColorTheme(newColor: String) {
        
        //change background and tint colors
        if (newColor == "Orange") {
            self.view.backgroundColor = UIColor(hexString: "#ffb366")
            facesView.backgroundColor = UIColor(hexString: "#ffb366")
            self.view.tintColor = UIColor.white
        }
        else if (newColor == "Light") {
            self.view.backgroundColor = UIColor.white
            facesView.backgroundColor = UIColor.white
            self.view.tintColor = UIColor.blue
        }
        else if (newColor == "Blue Light") {
            self.view.backgroundColor = UIColor(hexString: "#bbffff")
            facesView.backgroundColor = UIColor(hexString: "#bbffff")
            self.view.tintColor = UIColor(hexString: "#9f79ee")
        }
    }
    
    func updateToPreviousTotal() {
        let userPreferences = UserPreferences()
        let previousBill = userPreferences.previousBill
        if previousBill != UserPreferences.DefaultBill && userPreferences.billWasEnteredRecently() {
            billField.text = String(previousBill)
            updateTip(previousBill)
        }
    }
    
    fileprivate func billAsDouble() -> Double? {
        return billField.text.map {
            ($0 as NSString).doubleValue
        }
    }
    
    fileprivate func tipPercentage() -> Double {
        let selectedIndex = tipControl.selectedSegmentIndex
        return tipControl.titleForSegment(at: selectedIndex).map { amount in
            return convertPercentageStringToDouble(amount)
            } ?? defaultTipAmount
    }
    
    fileprivate func convertPercentageStringToDouble(_ percentageString: String) -> Double {
        let arrayOfNumbers  = percentageString.characters.flatMap { Int(String($0)) }
        let stringOfNumbers = arrayOfNumbers.map(String.init).joined(separator: "") as NSString
        
        return stringOfNumbers.doubleValue / 100.0
    }
    
    fileprivate func formatCurrency(_ amount: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = availableLocales[localeControl.selectedSegmentIndex]
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.alwaysShowsDecimalSeparator = false
        currencyFormatter.numberStyle = .currency
        
        return currencyFormatter.string(from: amount as NSNumber)!
    }
}

