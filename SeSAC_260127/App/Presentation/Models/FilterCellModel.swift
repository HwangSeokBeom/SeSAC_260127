//
//  FilterCellModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct FilterCellModel {
    let title: String
    let filter: PhotoColor
}

extension FilterCellModel {
    init(filter: PhotoColor) {
        self.title = filter.title
        self.filter = filter
    }
}
