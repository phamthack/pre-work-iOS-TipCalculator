//
//  SettingViewController.swift
//  TipCalculator
//
//  Created by Phạm Thanh Hùng on 5/28/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    @IBOutlet weak var lowField: UITextField!
    @IBOutlet weak var middleField: UITextField!
    @IBOutlet weak var highField: UITextField!
    
    var userPreferences: UserPreferences!
    
    let availableLocales = [
        "en_US": Locale(identifier: "en_US"),
        "en_UK": Locale(identifier: "en_UK"),
        "vi_VN": Locale(identifier: "vi_VN")
    ]
    
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
    
    func submittedTipValue(_ text: String?) -> Int? {
        return text.flatMap { Int($0) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTipFields()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateTipFields()
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
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath)")
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