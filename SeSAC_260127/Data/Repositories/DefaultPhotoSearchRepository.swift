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
        completion: @escaping (Result<[Photo], NetworkError>) -> Void
    ) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedQuery.isEmpty {
            fetchList(page: page, perPage: perPage, completion: completion)
        } else {
            search(query: trimmedQuery, color: color, sort: sort, page: page, perPage: perPage, completion: completion)
        }
    }

    private func fetchList(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], NetworkError>) -> Void
    ) {
        remote.fetchList(page: page, perPage: perPage) { result in
            completion(result.map { $0.map(UnsplashPhotoMapper.toPhoto) })
        }
    }

    private func search(
        query: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], NetworkError>) -> Void
    ) {
        remote.search(query: query, color: color, sort: sort, page: page, perPage: perPage) { result in
            completion(result.map { $0.map(UnsplashPhotoMapper.toPhoto) })
        }
    }
}
