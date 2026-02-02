//
//  DailyStatCellModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct DailyStatCellModel {
    let dateText: String
    let valueText: String

    init(domain: DailyStat) {
        self.dateText = DisplayFormatter.statChartDate(domain.date)
        self.valueText = DisplayFormatter.decimal(domain.value)
    }
}
