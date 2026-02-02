//
//  DisplayFormatter.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

enum DisplayFormatter {

    private static let decimalNumber: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()

    private static let photoCreatedDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy년 M월 d일"
        f.locale = Locale(identifier: "ko_KR")
        return f
    }()

    private static let statChartDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd"
        f.locale = Locale(identifier: "ko_KR")
        return f
    }()

    static func decimal(_ value: Int) -> String {
        decimalNumber.string(from: value as NSNumber) ?? "\(value)"
    }

    static func photoCreatedDate(_ date: Date) -> String {
        photoCreatedDateFormatter.string(from: date)
    }

    static func statChartDate(_ date: Date) -> String {
        statChartDateFormatter.string(from: date)
    }
}
