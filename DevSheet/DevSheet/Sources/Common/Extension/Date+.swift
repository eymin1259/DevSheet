//
//  Date+.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation

extension Date {
    func getToday() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
