//
//  UnsplashPhotoRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
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
        let endpoint = UnsplashEndpoint.photoList(page: page, perPage: perPage)

        network.requestDecodable(
            [UnsplashPhotoDTO].self,
            endpoint: endpoint,
            headers: authHeaders
        ) { completion($0) }
    }

    func search(
        query: String,
        color: PhotoColor?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[UnsplashPhotoDTO], Error>) -> Void
    ) {
        let endpoint = UnsplashEndpoint.searchPhotos(
            query: query,
            color: color,
            sort: sort,
            page: page,
            perPage: perPage
        )

        network.requestDecodable(
            UnsplashSearchResponseDTO.self,
            endpoint: endpoint,
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
