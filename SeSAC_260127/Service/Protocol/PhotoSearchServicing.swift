//
//  PhotoSearchServicing.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

protocol PhotoSearchServicing {
    func search(
        query: String,
        color: PhotoColorFilter?,
        sort: PhotoSortOption,
        completion: @escaping (Result<[Photo], Error>) -> Void
    )
}
