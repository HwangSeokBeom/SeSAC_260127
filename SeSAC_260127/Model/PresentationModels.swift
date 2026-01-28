//
//  PresentationModels.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit

struct TopicCellModel {
    let title: String
    let imageURL: URL?
    let likeCountText: String
}

extension TopicCellModel {
    
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    init(domain: TopicItem) {
        self.title = domain.title
        self.imageURL = URL(string: domain.imageURLString)
        self.likeCountText = Self.formatter.string(from: domain.likeCount as NSNumber)
            ?? "\(domain.likeCount)"
    }
}

// MARK: - Photo Cell에 쓰는 모델
struct PhotoCellModel {
    let imageURL: URL?
    let likeCountText: String
    let isFavorite: Bool
}

extension PhotoCellModel {
    init(domain: Photo) {
        self.imageURL = domain.imageURL
        self.likeCountText = "\(domain.likeCount)"
        self.isFavorite = domain.isFavorite
    }
}

// MARK: - Filter Cell에 쓰는 모델
struct FilterCellModel {
    let title: String
    let color: UIColor
}

extension FilterCellModel {
    init(filter: PhotoColorFilter) {
        self.title = filter.title
        self.color  = filter.color
    }
}

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

// MARK: - Mapping from Domain

extension PhotoDetailHeaderModel {
    
    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        // 필요하면 locale 설정
        // f.locale = Locale(identifier: "ko_KR")
        return f
    }()
    
    init(domain: Photo) {
        self.mainImageURL = domain.imageURL
        self.userName = domain.userName
        self.userProfileImageURL = domain.userProfileImageURL
        
        if let createdAt = domain.createdAt {
            self.createdAtText = Self.dateFormatter.string(from: createdAt)
        } else {
            self.createdAtText = "날짜 정보 없음"
        }
        
        self.sizeText = "\(domain.width) x \(domain.height)"
        self.likeCountText = Self.numberFormatter.string(from: domain.likeCount as NSNumber)
            ?? "\(domain.likeCount)"
    }
}

extension PhotoDetailStatisticsModel {
    
    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    init(domain: PhotoStatistics) {
        self.totalViewsText = Self.numberFormatter.string(from: domain.totalViews as NSNumber)
            ?? "\(domain.totalViews)"
        self.totalDownloadsText = Self.numberFormatter.string(from: domain.totalDownloads as NSNumber)
            ?? "\(domain.totalDownloads)"
        
        self.viewsHistory = domain.viewsHistory.map { DailyStatCellModel(domain: $0) }
        self.downloadsHistory = domain.downloadsHistory.map { DailyStatCellModel(domain: $0) }
    }
}

extension DailyStatCellModel {
    
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        // f.locale = Locale(identifier: "ko_KR")
        return f
    }()
    
    init(domain: DailyStat) {
        self.dateText = Self.dateFormatter.string(from: domain.date)
        self.valueText = "\(domain.value)"
    }
}
