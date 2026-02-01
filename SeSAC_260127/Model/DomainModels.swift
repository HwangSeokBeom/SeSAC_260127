//
//  DomainModels.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

struct TopicItem {
    let id = UUID()
    let title: String
    let imageURLString: String
    let likeCount: Int
}

struct TopicSection {
    let title: String
    let items: [TopicItem]
}

struct Photo {
    let id: String
    let imageURL: URL?
    let likeCount: Int

    let width: Int
    let height: Int
    let userName: String
    let userProfileImageURL: URL?
    let createdAt: Date?
}

enum PhotoSortOption {
    case relevance
    case latest
}

struct PhotoStatistics {
    let width: Int
    let height: Int
    let totalViews: Int
    let totalDownloads: Int
    let viewsHistory: [DailyStat]
    let downloadsHistory: [DailyStat]
}

struct DailyStat {
    let date: Date
    let value: Int
}

