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
