//
//  PhotoColorFilter+UI.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit

extension PhotoColorFilter {
    
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
