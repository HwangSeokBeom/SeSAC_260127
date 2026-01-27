//
//  UnsplashTopicAPIService.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation
import Alamofire

final class UnsplashTopicAPIService: TopicAPIService {
    
    private let apiKey: String
    private let network: Networking
    
    init(
        apiKey: String,
        network: Networking = NetworkManager.shared
    ) {
        self.apiKey = apiKey
        self.network = network
    }
    
    // 메인 화면에서 사용할 토픽 구성
    private struct TopicConfig {
        let id: String      // Unsplash topic slug
        let title: String   // 섹션 타이틀
    }
    
    // 여기 토픽 ID/타이틀은 원하는 걸로 바꿔도 됨
    private let topicConfigs: [TopicConfig] = [
        .init(id: "golden-hour",         title: "Golden Hour"),
        .init(id: "nature",              title: "Nature"),
        .init(id: "animals",             title: "Animals"),
        .init(id: "architecture-interior", title: "Architecture"),
        .init(id: "people",              title: "People")
    ]
    
    func fetchTopics(completion: @escaping (Result<[TopicSection], Error>) -> Void) {
        let group = DispatchGroup()
        
        // 토픽별로 만들어진 섹션들
        var sections: [TopicSection] = []
        var firstError: Error?
        
        for config in topicConfigs {
            group.enter()
            
            fetchTopicPhotos(topicID: config.id) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let dtos):
                    let items = dtos.map { $0.toTopicItem() }
                    let section = TopicSection(title: config.title, items: items)
                    sections.append(section)
                    
                case .failure(let error):
                    // 하나라도 실패하면 일단 기억해두고,
                    if firstError == nil {
                        firstError = error
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = firstError, sections.isEmpty {
                completion(.failure(error))
            } else {
                // topicConfigs 순서대로 섹션 정렬
                let orderedSections = self.topicConfigs.compactMap { config in
                    sections.first(where: { $0.title == config.title })
                }
                completion(.success(orderedSections))
            }
        }
    }
    
    private func fetchTopicPhotos(
        topicID: String,
        completion: @escaping (Result<[UnsplashPhotoDTO], Error>) -> Void
    ) {
        let url = "https://api.unsplash.com/topics/\(topicID)/photos"
        
        let params: Parameters = [
            "page": 1,
            "per_page": 20,
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
                completion(.success(dtos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
