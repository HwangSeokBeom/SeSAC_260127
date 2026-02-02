//
//  UnsplashPhotoRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//


//
//  UnsplashPhotoRemoteDataSource.swift
//  SeSAC_260127
//

import Foundation
import Alamofire

final class UnsplashPhotoRemoteDataSource: PhotoSearchRemoteDataSource {

    private let apiKey: String
    private let network: Networking

    init(apiKey: String, network: Networking) {
        self.apiKey = apiKey
        self.network = network
    }

    private var authHeaders: HTTPHeaders {
        ["Authorization": "Client-ID \(apiKey)"]
    }

    func fetchList(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[UnsplashPhotoDTO], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/photos"
        let params: Parameters = ["page": page, "per_page": perPage]

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

    func search(
        query: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[UnsplashPhotoDTO], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/search/photos"
        let orderBy: String = (sort == .latest) ? "latest" : "relevant"

        var params: Parameters = [
            "query": query,
            "page": page,
            "per_page": perPage,
            "order_by": orderBy
        ]
        if let color { params["color"] = color.rawValue }

        network.requestDecodable(
            UnsplashSearchResponseDTO.self,
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: authHeaders
        ) { result in
            switch result {
            case .success(let dto):
                completion(.success(dto.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
