//
//  DefaultFetchTopicUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

final class FetchTopicUseCase: FetchTopicUseCasing {

    private let repository: TopicRepository

    init(repository: TopicRepository) {
        self.repository = repository
    }

    func fetchTopics(completion: @escaping (Result<[TopicSection], Error>) -> Void) {
        repository.fetchTopics(completion: completion)
    }
}
