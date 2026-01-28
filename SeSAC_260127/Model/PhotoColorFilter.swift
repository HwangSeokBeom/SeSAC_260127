//
//  PhotoColorFilter.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit

import Foundation

enum PhotoColorFilter: CaseIterable {
    case black, white, yellow, red, orange, green, blue, purple
    
    var title: String {
        switch self {
        case .black: return "블랙"
        case .white: return "화이트"
        case .yellow: return "옐로우"
        case .red: return "레드"
        case .orange: return "오렌지"
        case .green: return "그린"
        case .blue: return "블루"
        case .purple: return "퍼플"
        }
    }
}

struct FilterOption {
    let title: String
    let color: UIColor
}

extension PhotoColorFilter {
    
    var apiValue: String {
        switch self {
        case .black:  return "black"
        case .white:  return "white"
        case .yellow: return "yellow"
        case .red:    return "red"
        case .orange: return "orange"
        case .green:  return "green"
        case .blue:   return "blue"
        case .purple: return "purple"
        }
    }
}
