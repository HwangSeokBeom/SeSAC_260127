//
//  PhotoStatistics.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct PhotoStatistics: Equatable {
    let width: Int
    let height: Int
    let totalViews: Int
    let totalDownloads: Int
    let viewsHistory: [DailyStat]
    let downloadsHistory: [DailyStat]
}
