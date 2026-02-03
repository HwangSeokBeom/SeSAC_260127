//
//  DefaultSearchPhotosUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

final class DefaultSearchPhotosUseCase: SearchPhotosUseCase {

    private let repository: PhotoSearchRepository

    init(repository: PhotoSearchRepository) {
        self.repository = repository
    }

    func execute(
        rawQuery: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        repository.searchPhotos(
            query: rawQuery,
            color: color,
            sort: sort,
            page: page,
            perPage: perPage,
            completion: completion
        )
    }
}
