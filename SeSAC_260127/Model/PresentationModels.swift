//
//  PresentationModels.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation

struct TopicCellModel {
    let title: String
    let imageURL: URL?
    let likeCountText: String
}

extension TopicCellModel {

    init(domain: TopicItem) {
        self.title = domain.title
        self.imageURL = URL(string: domain.imageURLString)
        self.likeCountText = FormatterManager.decimalNumber.string(from: domain.likeCount as NSNumber)
            ?? "\(domain.likeCount)"
    }
}

// MARK: - Photo Cell

struct PhotoCellModel {
    let imageURL: URL?
    let likeCountText: String
    let isFavorite: Bool
}

extension PhotoCellModel {
    init(domain: Photo) {
        self.imageURL = domain.imageURL
        self.likeCountText = FormatterManager.decimalNumber.string(from: domain.likeCount as NSNumber)
            ?? "\(domain.likeCount)"
        self.isFavorite = domain.isFavorite
    }
}

// MARK: - Filter Cell

struct FilterCellModel {
    let title: String
    let filter: PhotoColorFilter
}

extension FilterCellModel {
    init(filter: PhotoColorFilter) {
        self.title = filter.title
        self.filter = filter 
    }
}

// MARK: - Detail Models

struct PhotoDetailHeaderModel {
    let mainImageURL: URL?
    let userName: String
    let userProfileImageURL: URL?
    let createdAtText: String
    let sizeText: String
    let likeCountText: String
}

struct PhotoDetailStatisticsModel {
    let totalViewsText: String
    let totalDownloadsText: String
    let viewsHistory: [DailyStatCellModel]
    let downloadsHistory: [DailyStatCellModel]
}

struct DailyStatCellModel {
    let dateText: String
    let valueText: String
}

// MARK: - Header Mapping

extension PhotoDetailHeaderModel {

    init(domain: Photo) {
        self.mainImageURL = domain.imageURL
        self.userName = domain.userName
        self.userProfileImageURL = domain.userProfileImageURL
        
        if let createdAt = domain.createdAt {
            self.createdAtText = FormatterManager.photoCreatedDate.string(from: createdAt)
        } else {
            self.createdAtText = "날짜 정보 없음"
        }
        
        self.sizeText = "\(domain.width) x \(domain.height)"
        self.likeCountText = FormatterManager.decimalNumber.string(from: domain.likeCount as NSNumber)
            ?? "\(domain.likeCount)"
    }
}

// MARK: - Statistics Mapping

extension PhotoDetailStatisticsModel {

    init(domain: PhotoStatistics) {
        self.totalViewsText = FormatterManager.decimalNumber.string(from: domain.totalViews as NSNumber)
            ?? "\(domain.totalViews)"
        
        self.totalDownloadsText = FormatterManager.decimalNumber.string(from: domain.totalDownloads as NSNumber)
            ?? "\(domain.totalDownloads)"
        
        self.viewsHistory = domain.viewsHistory.map { DailyStatCellModel(domain: $0) }
        self.downloadsHistory = domain.downloadsHistory.map { DailyStatCellModel(domain: $0) }
    }
}

// MARK: - Daily Stat Mapping

extension DailyStatCellModel {

    init(domain: DailyStat) {
        self.dateText = FormatterManager.statChartDate.string(from: domain.date)
        self.valueText = FormatterManager.decimalNumber.string(from: domain.value as NSNumber)
            ?? "\(domain.value)"
    }
}
