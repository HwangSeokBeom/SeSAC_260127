//
//  BirthDateError.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

enum BirthDateError: LocalizedError, Equatable {
    case empty(field: Field)
    case notNumber(field: Field)
    case yearOutOfRange(min: Int, max: Int)
    case monthOutOfRange
    case dayOutOfRange(maxDay: Int)

    enum Field: String {
        case year = "년"
        case month = "월"
        case day = "일"
    }

   var errorDescription: String? {
        switch self {
        case .empty(let f):
            return "\(f.rawValue)을(를) 입력해주세요."
        case .notNumber(let f):
            return "\(f.rawValue)은(는) 숫자만 입력해주세요."
        case .yearOutOfRange(let min, let max):
            return "년은 \(min)~\(max) 범위로 입력해주세요."
        case .monthOutOfRange:
            return "월은 1~12 범위로 입력해주세요."
        case .dayOutOfRange(let maxDay):
            return "일은 1~\(maxDay) 범위로 입력해주세요."
        }
    }
}
