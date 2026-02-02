//
//  UnsplashTopicRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

//
//  UnsplashTopicRemoteDataSource.swift
//  SeSAC_260127
//

import Foundation
import Alamofire

final class UnsplashTopicRemoteDataSource: TopicRemoteDataSource {

    private let apiKey: String
    private let network: Networking

    init(apiKey: String, network: Networking) {
        self.apiKey = apiKey
        self.network = network
    }

    private var authHeaders: HTTPHeaders {
        ["Authorization": "Client-ID \(apiKey)"]
    }

    func fetchTopicPhotos(
        topicID: String,
        completion: @escaping (Result<[UnsplashPhotoDTO], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/topics/\(topicID)/photos"
        let params: Parameters = ["page": 1, "per_page": 20]

        network.requestDecodable(
            [UnsplashPhotoDTO].self,
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: authHeaders
        ) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}
