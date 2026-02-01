//
//  UserDefaultsManager.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/1/26.
//

import Foundation

protocol LikeStoring: AnyObject {
    func isLiked(photoID: String) -> Bool
    @discardableResult func toggle(photoID: String) -> Bool
    func setLiked(_ liked: Bool, photoID: String)

    @discardableResult
    func addLikeObserver(_ observer: @escaping (_ photoID: String, _ isLiked: Bool) -> Void) -> UUID
    func removeLikeObserver(_ token: UUID)
}

final class UserDefaultsManager: LikeStoring {

    static let shared = UserDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private let likedKey = "liked_photo_ids"

    private var observers: [UUID: (String, Bool) -> Void] = [:]

    // MARK: - LikeStoring

    func isLiked(photoID: String) -> Bool {
        likedSet().contains(photoID)
    }

    @discardableResult
    func toggle(photoID: String) -> Bool {
        let newState: Bool
        var set = likedSet()

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
    func addLikeObserver(_ observer: @escaping (String, Bool) -> Void) -> UUID {
        let token = UUID()
        observers[token] = observer
        return token
    }

    func removeLikeObserver(_ token: UUID) {
        observers[token] = nil
    }

    private func likedSet() -> Set<String> {
        Set(defaults.stringArray(forKey: likedKey) ?? [])
    }

    private func saveLikedSet(_ set: Set<String>) {
        defaults.set(Array(set), forKey: likedKey)
    }

    private func notify(photoID: String, isLiked: Bool) {
        DispatchQueue.main.async { [observers] in
            observers.values.forEach { $0(photoID, isLiked) }
        }
    }
}
