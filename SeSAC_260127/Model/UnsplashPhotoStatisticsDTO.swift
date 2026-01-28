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
        let date: String  // "2024-01-01T00:00:00Z"
        let value: Int
    }
}

extension UnsplashPhotoStatisticsDTO {
    
    func toDomain(width: Int, height: Int) -> PhotoStatistics {
        
        let dateFormatter = FormatterManager.iso8601
        
        let viewsHistory: [DailyStat] = views.historical.values.compactMap { v in
            guard let date = dateFormatter.date(from: v.date) else { return nil }
            return DailyStat(date: date, value: v.value)
        }
        
        let downloadsHistory: [DailyStat] = downloads.historical.values.compactMap { v in
            guard let date = dateFormatter.date(from: v.date) else { return nil }
            return DailyStat(date: date, value: v.value)
        }
        
        return PhotoStatistics(
            width: width,
            height: height,
            totalViews: views.total,
            totalDownloads: downloads.total,
            viewsHistory: viewsHistory,
            downloadsHistory: downloadsHistory
        )
    }
}
