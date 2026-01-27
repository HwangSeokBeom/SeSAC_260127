//
//  UnsplashSearchResponse.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation

struct UnsplashSearchResponse: Decodable {
    let results: [UnsplashPhotoDTO]
}

struct UnsplashPhotoDTO: Decodable {
    let id: String
    let likes: Int
    let urls: URLInfo
    let description: String?
    let alt_description: String?
    
    struct URLInfo: Decodable {
        let small: String
        let regular: String?
    }
}

extension UnsplashPhotoDTO {
    func toDomainPhoto() -> Photo {
        let urlString = urls.small
        return Photo(
            id: id,
            imageURL: URL(string: urlString),
            likeCount: likes,
            isFavorite: false
        )
    }
    
    func toTopicItem() -> TopicItem {
        TopicItem(
            title: description ?? alt_description ?? "Untitled",
            imageURLString: urls.small,
            likeCount: likes
        )
    }
}
