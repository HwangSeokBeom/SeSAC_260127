//
//  UnsplashPhotoStatisticsRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

//
//  UnsplashPhotoStatisticsRemoteDataSource.swift
//  SeSAC_260127
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
        completion: @escaping (Result<UnsplashPhotoStatisticsDTO, Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/photos/\(photoID)/statistics"

        network.requestDecodable(
            UnsplashPhotoStatisticsDTO.self,
            url: url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: authHeaders
        ) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}
