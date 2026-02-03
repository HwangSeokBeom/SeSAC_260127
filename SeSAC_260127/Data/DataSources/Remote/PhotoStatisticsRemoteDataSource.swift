//
//  PhotoStatisticsRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

protocol PhotoStatisticsRemoteDataSource {
    func fetchStatistics(
        photoID: String,
        completion: @escaping (Result<UnsplashPhotoStatisticsDTO, NetworkError>) -> Void
    )
}
