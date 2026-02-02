//
//  UnsplashPhotoStatisticsDTO.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
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
