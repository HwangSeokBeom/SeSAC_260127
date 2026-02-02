//
//  DefaultLikeToggleUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

final class DefaultLikeToggleUseCase: LikeToggleUseCase {

    private let repository: LikeRepository

    init(repository: LikeRepository) {
        self.repository = repository
    }

    func isLiked(photoID: String) -> Bool {
        repository.isLiked(photoID: photoID)
    }

    @discardableResult
    func toggle(photoID: String) -> Bool {
        repository.toggle(photoID: photoID)
    }

    @discardableResult
    func observe(_ observer: @escaping (String, Bool) -> Void) -> UUID {
        repository.addObserver(observer)
    }

    func removeObserver(_ token: UUID) {
        repository.removeObserver(token)
    }
}
