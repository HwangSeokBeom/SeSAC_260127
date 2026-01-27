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
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 정렬 값
        let orderBy: String
        switch sort {
        case .relevance: orderBy = "relevant"
        case .latest:    orderBy = "latest"
        }
        
        if trimmed.isEmpty {
            fetchPhotoList(orderBy: orderBy, completion: completion)
        } else {
            searchPhotos(
                query: trimmed,
                color: color,
                orderBy: orderBy,
                completion: completion
            )
        }
    }
    
    // MARK: - Private
    
    /// /photos (전체 목록)
    private func fetchPhotoList(
        orderBy: String,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/photos"
        
        let params: Parameters = [
            "page": 1,
            "per_page": 20,
            "order_by": orderBy,
            "client_id": apiKey
        ]
        
        network.request(
            [UnsplashPhotoDTO].self,
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: nil
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
    
    /// /search/photos (검색)
    private func searchPhotos(
        query: String,
        color: PhotoColorFilter?,
        orderBy: String,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/search/photos"
        
        var params: Parameters = [
            "query": query,
            "page": 1,
            "per_page": 20,
            "order_by": orderBy,
            "client_id": apiKey
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
            headers: nil
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
