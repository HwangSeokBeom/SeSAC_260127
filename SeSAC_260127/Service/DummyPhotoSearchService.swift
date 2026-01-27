//
//  DummyPhotoSearchService.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//


import Foundation

// 지금은 네트워크 대신 더미 데이터로 구현
final class DummyPhotoSearchService: PhotoSearchServicing {
    
    func search(
        query: String,
        color: PhotoColorFilter?,
        sort: PhotoSortOption,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        // 나중에 교체하면 됨
        let dummy: [Photo] = [
            Photo(id: "1", imageURL: URL(string: "https://picsum.photos/300/200"), likeCount: 1643, isFavorite: false),
            Photo(id: "2", imageURL: URL(string: "https://picsum.photos/300/201"), likeCount: 3346, isFavorite: true),
            Photo(id: "3", imageURL: URL(string: "https://picsum.photos/300/202"), likeCount: 12,   isFavorite: false),
            Photo(id: "4", imageURL: URL(string: "https://picsum.photos/300/203"), likeCount: 46232,isFavorite: true)
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(dummy))
        }
    }
}
