//
//  UnsplashPhotoStatisticsDTO.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import Foundation

struct UnsplashPhotoStatisticsDTO: Decodable {
    let id: String
    let downloads: StatDTO
    let views: StatDTO
    
    struct StatDTO: Decodable {
        let total: Int
        let historical: HistoricalDTO
    }
    
    struct HistoricalDTO: Decodable {
        let values: [ValueDTO]
    }
    
    struct ValueDTO: Decodable {
        let date: String 
        let value: Int
    }
}

extension UnsplashPhotoStatisticsDTO {

    func toDomain(width: Int, height: Int) -> PhotoStatistics {

        let df = FormatterManager.iso8601

        func map(_ values: [ValueDTO]) -> [DailyStat] {
            let mapped = values.compactMap { v -> DailyStat? in
                guard let date = df.date(from: v.date) else { return nil }
                return DailyStat(date: date, value: v.value)
            }
            let sorted = mapped.sorted { $0.date < $1.date }
            return Array(sorted.suffix(30))
        }

        return PhotoStatistics(
            width: width,
            height: height,
            totalViews: views.total,
            totalDownloads: downloads.total,
            viewsHistory: map(views.historical.values),
            downloadsHistory: map(downloads.historical.values)
        )
    }
}
