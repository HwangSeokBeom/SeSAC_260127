//
//  TopicCellModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct TopicCellModel {
    let title: String
    let imageURL: URL?
    let likeCountText: String

    init(domain: TopicItem) {
        self.title = domain.title
        self.imageURL = URL(string: domain.imageURLString)
        self.likeCountText = DisplayFormatter.decimal(domain.likeCount)
    }
}
