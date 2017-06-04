//
//  SettingViewController.swift
//  TipCalculator
//
//  Created by Phạm Thanh Hùng on 5/28/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate  {
    
    @IBOutlet weak var lowField: UITextField!
    @IBOutlet weak var middleField: UITextField!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var highField: UITextField!
    @IBOutlet weak var localeControl: UISegmentedControl!
    
    var pickerData: [String] = [String]()
    
    var userPreferences: UserPreferences!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        userPreferences = UserPreferences()
    }
    
    @IBAction func onUpdateChanged(_ textField: UITextField) {
        if let newDefaultTipValue = (submittedTipValue(textField.text)) {
            switch textField.tag {
            case 1:
                userPreferences.lowTipPercentage = newDefaultTipValue
            case 2:
                userPreferences.mediumTipPercentage = newDefaultTipValue
            case 3:
                userPreferences.highTipPercentage = newDefaultTipValue
            default:
                ()
            }
            
            userPreferences.save()
        }
    }
    
    @IBAction func onChangeLocale(_ sender: Any) {
        userPreferences.preferredLocale = localeControl.selectedSegmentIndex
        
        userPreferences.save()
    }

    func submittedTipValue(_ text: String?) -> Int? {
        return text.flatMap { Int($0) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //connect the data
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        //fill the array
        pickerData = ["Orange", "Light", "Blue Light"]
        
        updateTipFields()
        updateLocale()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateTipFields()
        updateLocale()
        
        updateTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will disapear")
        
        for field in [lowField, middleField, highField] {
            field?.endEditing(true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTipFields() {
        lowField.text    = String(userPreferences.lowTipPercentage)
        middleField.text = String(userPreferences.mediumTipPercentage)
        highField.text   = String(userPreferences.highTipPercentage)
    }
    
    func updateLocale() {
        localeControl.selectedSegmentIndex = userPreferences.preferredLocale
    }
    
    func updateTheme() {
        let newColor = userPreferences.defaultColor
        changeColorTheme(newColor: newColor)
        
        let defaultRow = userPreferences.defaultRow
        colorPicker.selectRow(defaultRow, inComponent: 0, animated: false)

    }
    
    func changeColorTheme(newColor: String) {
        userPreferences.defaultColor = newColor
        
        //change background and tint colors
        if (newColor == "Orange") {
            self.view.backgroundColor = UIColor(hexString: "#ffb366")
            self.view.tintColor = UIColor.white
            userPreferences.defaultRow = 0
        }
        else if (newColor == "Light") {
            self.view.backgroundColor = UIColor.white
            self.view.tintColor = UIColor.blue
            userPreferences.defaultRow = 1
        }
        else if (newColor == "Blue Light") {
            self.view.backgroundColor = UIColor(hexString: "#bbffff")
            self.view.tintColor = UIColor(hexString: "#9f79ee")
            userPreferences.defaultRow = 2
        }
        
        userPreferences.save()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if userPreferences.defaultColor == "Orange" {
            cell.backgroundColor = UIColor(hexString: "#ffb366")
        } else if userPreferences.defaultColor == "Light" {
            cell.backgroundColor = UIColor.white
        }else if userPreferences.defaultColor == "Blue Light" {
            cell.backgroundColor = UIColor(hexString: "#bbffff")
        }
    }
    
    //MARK: - Delegates and data sources for colorPicker
    //data sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeColorTheme(newColor: pickerData[row])
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        userPreferences.save()
    }
}
