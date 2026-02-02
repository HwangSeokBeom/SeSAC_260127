//
//  PhotoDetailStatisticsModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct PhotoDetailStatisticsModel {
    let totalViewsText: String
    let totalDownloadsText: String
    let viewsHistory: [DailyStatCellModel]
    let downloadsHistory: [DailyStatCellModel]

    init(domain: PhotoStatistics) {
        self.totalViewsText = DisplayFormatter.decimal(domain.totalViews)
        self.totalDownloadsText = DisplayFormatter.decimal(domain.totalDownloads)
        self.viewsHistory = domain.viewsHistory.map { DailyStatCellModel(domain: $0) }
        self.downloadsHistory = domain.downloadsHistory.map { DailyStatCellModel(domain: $0) }
    }
}
