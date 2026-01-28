//
//  UnsplashPhotoStatisticsService.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import Foundation
import Alamofire

final class UnsplashPhotoStatisticsService: PhotoStatisticsServicing {
    
    private let apiKey: String
    private let network: Networking
    
    init(
        apiKey: String,
        network: Networking = NetworkManager.shared
    ) {
        self.apiKey = apiKey
        self.network = network
    }
    
    func fetchStatistics(
        photoID: String,
        width: Int,
        height: Int,
        completion: @escaping (Result<PhotoStatistics, Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/photos/\(photoID)/statistics"
        
        let params: Parameters = [
            "client_id": apiKey
        ]
        
        network.request(
            UnsplashPhotoStatisticsDTO.self,
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: nil
        ) { result in
            switch result {
            case .success(let dto):
                let stats = dto.toDomain(width: width, height: height)
                completion(.success(stats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
