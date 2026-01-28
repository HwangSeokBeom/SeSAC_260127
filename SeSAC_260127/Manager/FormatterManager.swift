//
//  FormatterManager.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import Foundation


enum FormatterManager {
    
    // 숫자: 12,345 형식
    static let decimalNumber: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    // Photo createdAt 용 날짜
    static let photoCreatedDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy년 M월 d일"
        f.locale = Locale(identifier: "ko_KR")
        return f
    }()
    
    // 통계 데이터(viewsHistory, downloadsHistory) 날짜용
    static let statChartDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd"   // 예: 01/22
        f.locale = Locale(identifier: "ko_KR")
        return f
    }()
    
    static let iso8601: ISO8601DateFormatter = {
            let f = ISO8601DateFormatter()
            // 필요하면 formatOptions 조절 가능
            // f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return f
        }()
}
