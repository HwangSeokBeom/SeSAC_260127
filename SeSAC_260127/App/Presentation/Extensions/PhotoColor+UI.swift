//
//  PhotoColor+UI.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import UIKit

extension PhotoColor {
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

    var uiColor: UIColor {
        switch self {
        case .black: return .black
        case .white: return .white
        case .yellow: return .systemYellow
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .green: return .systemGreen
        case .blue: return .systemBlue
        case .purple: return .systemPurple
        }
    }
}
