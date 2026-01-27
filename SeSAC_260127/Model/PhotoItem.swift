//
//  PhotoItem.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation

struct PhotoItem {
    let imageURL: URL?
    let likeCountText: String
    let isFavorite: Bool
}

extension PhotoItem {
    init(photo: Photo) {
        self.imageURL = photo.imageURL
        self.likeCountText = "\(photo.likeCount)"
        self.isFavorite = photo.isFavorite
    }
}
