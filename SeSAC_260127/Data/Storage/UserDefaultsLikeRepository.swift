//
//  UserDefaultsLikeRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

final class UserDefaultsLikeRepository: LikeRepository {

    private let defaults: UserDefaults
    private let likedKey: String

    private var observers: [UUID: (String, Bool) -> Void] = [:]

    init(
        defaults: UserDefaults = .standard,
        likedKey: String = "liked_photo_ids"
    ) {
        self.defaults = defaults
        self.likedKey = likedKey
    }

    func isLiked(photoID: String) -> Bool {
        likedSet().contains(photoID)
    }

    @discardableResult
    func toggle(photoID: String) -> Bool {
        var set = likedSet()
        let newState: Bool

        if set.contains(photoID) {
            set.remove(photoID)
            newState = false
        } else {
            set.insert(photoID)
            newState = true
        }

        saveLikedSet(set)
        notify(photoID: photoID, isLiked: newState)
        return newState
    }

    func setLiked(_ liked: Bool, photoID: String) {
        var set = likedSet()
        if liked { set.insert(photoID) } else { set.remove(photoID) }
        saveLikedSet(set)
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

    private func likedSet() -> Set<String> {
        Set(defaults.stringArray(forKey: likedKey) ?? [])
    }

    private func saveLikedSet(_ set: Set<String>) {
        defaults.set(Array(set), forKey: likedKey)
    }

    private func notify(photoID: String, isLiked: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.observers.values.forEach { $0(photoID, isLiked) }
        }
    }
}
