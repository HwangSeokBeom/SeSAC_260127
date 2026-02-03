//
//  DefaultPhotoStatisticsRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

final class DefaultPhotoStatisticsRepository: PhotoStatisticsRepository {

    private let remote: PhotoStatisticsRemoteDataSource

    init(remote: PhotoStatisticsRemoteDataSource) {
        self.remote = remote
    }

    func fetchStatistics(
        photoID: String,
        width: Int,
        height: Int,
        completion: @escaping (Result<PhotoStatistics, NetworkError>) -> Void
    ) {
        remote.fetchStatistics(photoID: photoID) { result in
            switch result {
            case .success(let dto):
                let stats = UnsplashStatisticsMapper.toPhotoStatistics(dto, width: width, height: height)
                completion(.success(stats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
