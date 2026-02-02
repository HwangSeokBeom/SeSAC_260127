//
//  UserDefaultsLikeRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

final class UserDefaultsLikeStorage: LikeStorage {

    private let defaults: UserDefaults
    private let likedKey: String

    init(defaults: UserDefaults = .standard, likedKey: String = "liked_photo_ids") {
        self.defaults = defaults
        self.likedKey = likedKey
    }

    func likedIDs() -> Set<String> {
        Set(defaults.stringArray(forKey: likedKey) ?? [])
    }

    func saveLikedIDs(_ ids: Set<String>) {
        defaults.set(Array(ids), forKey: likedKey)
    }
}
