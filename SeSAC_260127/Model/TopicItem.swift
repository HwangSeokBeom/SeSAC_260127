//
//  TopicItem.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

struct TopicItem {
    let id = UUID()
    let title: String
    let imageName: String
    let likeCount: Int
}

struct TopicSection {
    let title: String
    let items: [TopicItem]
}
