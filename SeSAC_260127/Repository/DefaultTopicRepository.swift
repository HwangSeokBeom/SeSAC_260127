//
//  DefaultTopicRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

final class DefaultTopicRepository: TopicRepository {

    private let api: TopicAPIService

    init(api: TopicAPIService) {
        self.api = api
    }

    func fetchTopics(completion: @escaping (Result<[TopicSection], Error>) -> Void) {
        api.requestTopicSections(completion: completion)
    }
}
