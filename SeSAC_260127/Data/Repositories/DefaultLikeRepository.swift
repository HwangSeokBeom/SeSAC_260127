//
//  DefaultLikeRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

final class DefaultLikeRepository: LikeRepository {

    private let storage: LikeStorage
    private let callbackQueue: DispatchQueue

    private var observers: [UUID: (String, Bool) -> Void] = [:]

    init(storage: LikeStorage, callbackQueue: DispatchQueue = .main) {
        self.storage = storage
        self.callbackQueue = callbackQueue
    }

    func isLiked(photoID: String) -> Bool {
        storage.likedIDs().contains(photoID)
    }

    @discardableResult
    func toggle(photoID: String) -> Bool {
        var set = storage.likedIDs()
        let newState: Bool

        if set.contains(photoID) {
            set.remove(photoID)
            newState = false
        } else {
            set.insert(photoID)
            newState = true
        }

        storage.saveLikedIDs(set)
        notify(photoID: photoID, isLiked: newState)
        return newState
    }

    func setLiked(_ liked: Bool, photoID: String) {
        var set = storage.likedIDs()
        if liked { set.insert(photoID) } else { set.remove(photoID) }
        storage.saveLikedIDs(set)
        notify(photoID: photoID, isLiked: liked)
    }

    @discardableResult
    func addObserver(_ observer: @escaping (String, Bool) -> Void) -> UUID {
        let token = UUID()
        observers[token] = observer
        return token
    }

    func removeObserver(_ token: UUID) {
        observers[token] = nil
    }

    private func notify(photoID: String, isLiked: Bool) {
        let currentObservers = observers.values
        callbackQueue.async {
            currentObservers.forEach { $0(photoID, isLiked) }
        }
    }
}
