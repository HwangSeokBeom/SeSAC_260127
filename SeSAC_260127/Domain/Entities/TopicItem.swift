//
//  TopicItem.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct TopicItem: Equatable, Identifiable {
    let id: UUID
    let title: String
    let imageURLString: String
    let likeCount: Int

    init(id: UUID = UUID(), title: String, imageURLString: String, likeCount: Int) {
        self.id = id
        self.title = title
        self.imageURLString = imageURLString
        self.likeCount = likeCount
    }
}
