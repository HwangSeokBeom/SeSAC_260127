//
//  UnsplashPhotoSearchService.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation
import Alamofire

final class UnsplashPhotoSearchService: PhotoSearchServicing {

    private let apiKey: String
    private let network: Networking

    init(
        apiKey: String,
        network: Networking = NetworkManager.shared
    ) {
        self.apiKey = apiKey
        self.network = network
    }

    func search(
        query: String,
        color: PhotoColorFilter?,
        sort: PhotoSortOption,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            fetchPhotoList(page: page, perPage: perPage, completion: completion)
            return
        }

        let orderBy: String
        switch sort {
        case .latest: orderBy = "latest"
        case .relevance: orderBy = "relevant"
        }

        searchPhotos(
            query: trimmed,
            color: color,
            page: page,
            perPage: perPage,
            orderBy: orderBy,
            completion: completion
        )
    }

    private var authHeaders: HTTPHeaders {
        ["Authorization": "Client-ID \(apiKey)"]
    }

    private func fetchPhotoList(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/photos"

        let params: Parameters = [
            "page": page,
            "per_page": perPage
        ]

        network.request(
            [UnsplashPhotoDTO].self,
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: authHeaders
        ) { result in
            switch result {
            case .success(let dtos):
                let photos = dtos.map { $0.toDomainPhoto() }
                completion(.success(photos))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func searchPhotos(
        query: String,
        color: PhotoColorFilter?,
        page: Int,
        perPage: Int,
        orderBy: String,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/search/photos"

        var params: Parameters = [
            "query": query,
            "page": page,
            "per_page": perPage,
            "order_by": orderBy
        ]

        if let color {
            params["color"] = color.apiValue
        }

        network.request(
            UnsplashSearchResponse.self,
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: authHeaders
        ) { result in
            switch result {
            case .success(let response):
                let photos = response.results.map { $0.toDomainPhoto() }
                completion(.success(photos))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
