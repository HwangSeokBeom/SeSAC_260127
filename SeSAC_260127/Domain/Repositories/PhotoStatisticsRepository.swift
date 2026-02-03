//
//  PhotoStatisticsRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

protocol PhotoStatisticsRepository {
    func fetchStatistics(
        photoID: String,
        width: Int,
        height: Int,
        completion: @escaping (Result<PhotoStatistics, NetworkError>) -> Void
    )
}
