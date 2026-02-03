//
//  SearchQueryError.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

enum SearchQueryError: LocalizedError {
    case tooShort(min: Int)
    case tooLong(max: Int)
    case invalidCharacters

    var errorDescription: String? {
        switch self {
        case .tooShort(let min): return "검색어는 최소 \(min)자 이상이어야 합니다."
        case .tooLong(let max): return "검색어는 최대 \(max)자까지 입력 가능합니다."
        case .invalidCharacters: return "검색어에 허용되지 않은 문자가 포함되어 있습니다."
        }
    }
}

