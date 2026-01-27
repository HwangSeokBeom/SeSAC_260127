//
//  PhotoColorFilter.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit

enum PhotoColorFilter: CaseIterable {
    case black, white, yellow, red, orange, green, blue, navy, purple
    
    var title: String {
        switch self {
        case .black: return "블랙"
        case .white: return "화이트"
        case .yellow: return "옐로우"
        case .red: return "레드"
        case .orange: return "오렌지"
        case .green: return "그린"
        case .blue: return "블루"
        case .navy: return "네이비"
        case .purple: return "퍼플"
        }
    }
    
    var color: UIColor {
        switch self {
        case .black: return .black
        case .white: return .white
        case .yellow: return .systemYellow
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .green: return .systemGreen
        case .blue: return .systemBlue
        case .navy: return .systemIndigo
        case .purple: return .systemPurple
        }
    }
}

struct FilterOption {
    let title: String
    let color: UIColor
}

