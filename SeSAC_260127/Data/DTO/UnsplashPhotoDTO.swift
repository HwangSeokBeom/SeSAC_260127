//
//  UnsplashPhotoDTO.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct UnsplashPhotoDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let likes: Int
    let urls: URLInfo
    let user: UserDTO
    let createdAt: String
    let description: String?
    let altDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, width, height, likes, urls, user, description
        case createdAt = "created_at"
        case altDescription = "alt_description"
    }

    struct URLInfo: Decodable {
        let small: String
        let regular: String?
    }

    struct UserDTO: Decodable {
        let name: String
        let profileImage: ProfileImageDTO

        enum CodingKeys: String, CodingKey {
            case name
            case profileImage = "profile_image"
        }

        struct ProfileImageDTO: Decodable {
            let small: String
            let medium: String?
        }
    }
}
