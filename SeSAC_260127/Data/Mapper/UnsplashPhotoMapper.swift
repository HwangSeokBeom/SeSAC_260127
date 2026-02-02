//
//  Untitled.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

enum UnsplashPhotoMapper {

    static func toPhoto(_ dto: UnsplashPhotoDTO) -> Photo {
        Photo(
            id: dto.id,
            imageURL: URL(string: dto.urls.small),
            likeCount: dto.likes,
            width: dto.width,
            height: dto.height,
            userName: dto.user.name,
            userProfileImageURL: URL(string: dto.user.profileImage.small),
            createdAt: ISO8601DateFormatter().date(from: dto.createdAt)
        )
    }

    static func toTopicItem(_ dto: UnsplashPhotoDTO) -> TopicItem {
        TopicItem(
            title: dto.description ?? dto.altDescription ?? "Untitled",
            imageURLString: dto.urls.small,
            likeCount: dto.likes
        )
    }
}
