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
    let width: Int
    let height: Int
    let likes: Int
    let urls: URLInfo
    let user: UserDTO
    let created_at: String          
    let description: String?
    let alt_description: String?
    
    struct URLInfo: Decodable {
        let small: String
        let regular: String?
    }
    
    struct UserDTO: Decodable {
        let name: String
        let profile_image: ProfileImageDTO
        
        struct ProfileImageDTO: Decodable {
            let small: String
            let medium: String?
        }
    }
}

extension UnsplashPhotoDTO {
    
    func toDomainPhoto() -> Photo {
        let imageURL = URL(string: urls.small)
        let profileURL = URL(string: user.profile_image.small)
        
        let date: Date?
        if let parsed = ISO8601DateFormatter().date(from: created_at) {
            date = parsed
        } else {
            date = nil
        }
        
        return Photo(
            id: id,
            imageURL: imageURL,
            likeCount: likes,
            isFavorite: false,
            width: width,
            height: height,
            userName: user.name,
            userProfileImageURL: profileURL,
            createdAt: date
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

