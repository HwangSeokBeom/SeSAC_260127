//
//  PhotoSearchRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

protocol PhotoSearchRemoteDataSource {
    func search(
        query: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[UnsplashPhotoDTO], NetworkError>) -> Void
    )

    func fetchList(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[UnsplashPhotoDTO], NetworkError>) -> Void
    )
}
