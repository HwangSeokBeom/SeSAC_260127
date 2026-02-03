//
//  UnsplashPhotoStatisticsRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation
import Alamofire

final class UnsplashPhotoStatisticsRemoteDataSource: PhotoStatisticsRemoteDataSource {

    private let apiKey: String
    private let network: Networking

    init(apiKey: String, network: Networking) {
        self.apiKey = apiKey
        self.network = network
    }

    private var authHeaders: HTTPHeaders {
        ["Authorization": "Client-ID \(apiKey)"]
    }

    func fetchStatistics(
        photoID: String,
        completion: @escaping (Result<UnsplashPhotoStatisticsDTO, NetworkError>) -> Void
    ) {
        let endpoint = UnsplashEndpoint.photoStatistics(id: photoID)

        network.requestDecodable(
            UnsplashPhotoStatisticsDTO.self,
            endpoint: endpoint,
            headers: authHeaders
        ) { completion($0) }
    }
}
