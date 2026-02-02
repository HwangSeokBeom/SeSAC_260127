//
//  PhotoCellModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct PhotoCellModel {
    let id: String
    let imageURL: URL?
    let likeCountText: String
    let isFavorite: Bool

    init(domain: Photo, isFavorite: Bool) {
        self.id = domain.id
        self.imageURL = domain.imageURL
        self.likeCountText = DisplayFormatter.decimal(domain.likeCount)
        self.isFavorite = isFavorite
    }
    
    init(id: String, imageURL: URL?, likeCountText: String, isFavorite: Bool) {
        self.id = id
        self.imageURL = imageURL
        self.likeCountText = likeCountText
        self.isFavorite = isFavorite
    }
}


