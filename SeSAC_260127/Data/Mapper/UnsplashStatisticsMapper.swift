//
//  UnsplashStatisticsMapper.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

enum UnsplashStatisticsMapper {

    static func toPhotoStatistics(
        _ dto: UnsplashPhotoStatisticsDTO,
        width: Int,
        height: Int
    ) -> PhotoStatistics {

        func map(_ values: [UnsplashPhotoStatisticsDTO.ValueDTO]) -> [DailyStat] {
            values.compactMap { v in
                guard let date = APIDateParser.unsplashStatDate.date(from: v.date) else { return nil }
                return DailyStat(date: date, value: v.value)
            }
            .sorted { $0.date < $1.date }
        }

        return PhotoStatistics(
            width: width,
            height: height,
            totalViews: dto.views.total,
            totalDownloads: dto.downloads.total,
            viewsHistory: map(dto.views.historical.values),
            downloadsHistory: map(dto.downloads.historical.values)
        )
    }
}
