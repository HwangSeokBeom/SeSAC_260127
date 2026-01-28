//
//  PhotoStatisticsRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

protocol PhotoStatisticsRepository {
    func fetchStatistics(
        photoID: String,
        width: Int,
        height: Int,
        completion: @escaping (Result<PhotoStatistics, Error>) -> Void
    )
}

final class DefaultPhotoStatisticsRepository: PhotoStatisticsRepository {
    
    private let service: PhotoStatisticsServicing 
    
    init(service: PhotoStatisticsServicing) {
        self.service = service
    }
    
    func fetchStatistics(
        photoID: String,
        width: Int,
        height: Int,
        completion: @escaping (Result<PhotoStatistics, Error>) -> Void
    ) {
        service.fetchStatistics(
            photoID: photoID,
            width: width,
            height: height
        ) { result in
            // NetworkError를 쓰고 있다면 여기서 Error로 올려주기
            completion(result.mapError { $0 as Error })
        }
    }
}
