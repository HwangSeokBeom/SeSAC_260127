//
//  LikeToggleUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

protocol LikeToggleUseCase {
    @discardableResult
    func toggle(photoID: String) -> Bool

    func isLiked(photoID: String) -> Bool

    @discardableResult
    func observe(
        _ observer: @escaping (_ photoID: String, _ isLiked: Bool) -> Void
    ) -> UUID

    func removeObserver(_ token: UUID)
}
