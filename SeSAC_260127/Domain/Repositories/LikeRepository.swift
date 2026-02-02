//
//  LikeRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

protocol LikeRepository: AnyObject {
    func isLiked(photoID: String) -> Bool
    @discardableResult func toggle(photoID: String) -> Bool
    func setLiked(_ liked: Bool, photoID: String)

    @discardableResult
    func addObserver(_ observer: @escaping (_ photoID: String, _ isLiked: Bool) -> Void) -> UUID
    func removeObserver(_ token: UUID)
}
