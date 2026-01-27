//
//  DefaultTopicRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

import Foundation

final class DefaultTopicRepository: TopicRepository {
    
    private let service: TopicAPIService
    
    init(service: TopicAPIService) {
        self.service = service
    }
    
    func fetchTopics(
        completion: @escaping (Result<[TopicSection], Error>) -> Void
    ) {
        service.fetchTopics(completion: completion)
    }
}
