//
//  PhotoSearchRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

protocol PhotoSearchRepository {
    func searchPhotos(
        query: String,
        color: PhotoColorFilter?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    )
}
