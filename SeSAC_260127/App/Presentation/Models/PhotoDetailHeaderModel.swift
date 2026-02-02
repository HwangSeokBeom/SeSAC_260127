//
//  PhotoDetailHeaderModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct PhotoDetailHeaderModel {
    let photoID: String
    let mainImageURL: URL?
    let userName: String
    let userProfileImageURL: URL?
    let createdAtText: String
    let sizeText: String
    let likeCountText: String
    let isFavorite: Bool

    init(domain: Photo, isFavorite: Bool) {
        self.photoID = domain.id
        self.mainImageURL = domain.imageURL
        self.userName = domain.userName
        self.userProfileImageURL = domain.userProfileImageURL

        if let createdAt = domain.createdAt {
            self.createdAtText = DisplayFormatter.photoCreatedDate(createdAt)
        } else {
            self.createdAtText = "날짜 정보 없음"
        }

        self.sizeText = "\(domain.width) x \(domain.height)"
        self.likeCountText = DisplayFormatter.decimal(domain.likeCount)
        self.isFavorite = isFavorite
    }
}
