//
//  PhotoSearchRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

protocol PhotoSearchRepository {
    func searchPhotos(
        query: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], NetworkError>) -> Void
    )
}
