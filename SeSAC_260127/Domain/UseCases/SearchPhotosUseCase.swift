//
//  SearchPhotosUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

protocol SearchPhotosUseCase {
    func execute(
        rawQuery: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    )
}
