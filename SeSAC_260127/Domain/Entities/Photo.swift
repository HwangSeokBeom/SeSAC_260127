//
//  Photo.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct Photo: Equatable, Identifiable {
    let id: String
    let imageURL: URL?
    let likeCount: Int

    let width: Int
    let height: Int
    let userName: String
    let userProfileImageURL: URL?
    let createdAt: Date?
}
