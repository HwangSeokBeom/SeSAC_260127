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
    let isFavorite: Bool
}

enum PhotoSortOption {
    case relevance
    case latest
}



