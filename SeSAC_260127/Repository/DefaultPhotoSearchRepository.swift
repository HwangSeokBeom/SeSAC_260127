//
//  DefaultPhotoSearchRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation

final class DefaultPhotoSearchRepository: PhotoSearchRepository {
    
    private let service: PhotoSearchServicing
    
    init(service: PhotoSearchServicing) {
        self.service = service
    }
    
    func searchPhotos(
        query: String,
        color: PhotoColorFilter?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        service.search(
            query: query,
            color: color,
            sort: sort,
            page: page,
            perPage: perPage,
            completion: completion
        )
    }
}
