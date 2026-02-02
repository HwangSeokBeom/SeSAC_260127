//
//  DefaultPhotoSearchRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

final class DefaultPhotoSearchRepository: PhotoSearchRepository {

    private let remote: PhotoSearchRemoteDataSource

    init(remote: PhotoSearchRemoteDataSource) {
        self.remote = remote
    }

    func searchPhotos(
        query: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            remote.fetchList(page: page, perPage: perPage) { result in
                completion(result.map { $0.map(UnsplashPhotoMapper.toPhoto) })
            }
            return
        }

        remote.search(query: trimmed, color: color, sort: sort, page: page, perPage: perPage) { result in
            completion(result.map { $0.map(UnsplashPhotoMapper.toPhoto) })
        }
    }
}
