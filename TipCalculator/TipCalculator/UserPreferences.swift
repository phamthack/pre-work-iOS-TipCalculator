//
//  UserPreferences.swift
//  TipCalculator
//
//  Created by Phạm Thanh Hùng on 5/28/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import Foundation

struct UserPreferences {
    let defaults: UserDefaults
    
    let LocaleKey = "preferred_locale"
    let PreviousBill = "previous_bill"
    let PreviousBillDate = "previous_bill_date"
    static let DefaultBill = 0.0
    
    enum TipPercentageKey: String {
        case LowTip
        case MediumTip
        case HighTip
    }
    
    enum DefaultTip: Int {
        case low    = 18
        case medium = 20
        case high   = 25
    }
    
    var previousBill: Double {
        get {
            return defaults.value(forKey: PreviousBill) as? Double ?? UserPreferences.DefaultBill
        }
        
        set {
            previousBillDate = Date.timeIntervalSinceReferenceDate
            defaults.set(newValue, forKey: PreviousBill)
        }
    }
    
    var previousBillDate: TimeInterval {
        get {
            return defaults.value(forKey: PreviousBillDate) as? Double ?? 0.0
        }
        
        set {
            defaults.set(newValue, forKey: PreviousBillDate)
        }
    }
    
    var preferredLocale: String {
        get {
            return defaults.value(
                forKey: LocaleKey
                ) as? String ?? Locale.current.identifier
        }
        
        set {
            defaults.set(newValue, forKey: LocaleKey)
        }
    }
    
    var lowTipPercentage: Int {
        get {
            return defaults.value(
                forKey: TipPercentageKey.LowTip.rawValue
                ) as? Int ?? DefaultTip.low.rawValue
        }
        
        set {
            defaults.set(newValue, forKey: TipPercentageKey.LowTip.rawValue)
        }
    }
    
    var mediumTipPercentage: Int {
        get {
            return defaults.value(
                forKey: TipPercentageKey.MediumTip.rawValue
                ) as? Int ?? DefaultTip.medium.rawValue
        }
        
        set {
            defaults.set(newValue, forKey: TipPercentageKey.MediumTip.rawValue)
        }
    }
    
    var highTipPercentage: Int {
        get {
            return defaults.value(
                forKey: TipPercentageKey.HighTip.rawValue
                ) as? Int ?? DefaultTip.high.rawValue
        }
        
        set {
            defaults.set(newValue, forKey: TipPercentageKey.HighTip.rawValue)
        }
    }
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    func defaultTipPercentages() -> [Int] {
        return [lowTipPercentage, mediumTipPercentage, highTipPercentage]
    }
    
    func billWasEnteredRecently() -> Bool {
        let now = Date.timeIntervalSinceReferenceDate
        return (now - previousBillDate) < (10 * 60) // Ten minutes
    }
    
    func save() {
        print("Saving preferences: \(defaultTipPercentages())")
        
        defaults.synchronize()
    }
}
