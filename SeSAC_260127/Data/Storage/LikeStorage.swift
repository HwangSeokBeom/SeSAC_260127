//
//  LikeStorage.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

protocol LikeStorage {
    func likedIDs() -> Set<String>
    func saveLikedIDs(_ ids: Set<String>)
}
