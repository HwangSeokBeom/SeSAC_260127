//
//  UnsplashTopicRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
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
        completion: @escaping (Result<[UnsplashPhotoDTO], NetworkError>) -> Void
    ) {
        let endpoint = UnsplashEndpoint.topicPhotos(id: topicID, page: 1, perPage: 20)

        network.requestDecodable(
            [UnsplashPhotoDTO].self,
            endpoint: endpoint,
            headers: authHeaders
        ) { completion($0) }
    }
}
