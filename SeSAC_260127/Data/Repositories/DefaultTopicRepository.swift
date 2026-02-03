//
//  DefaultTopicRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

final class DefaultTopicRepository: TopicRepository {

    private struct TopicConfig {
        let id: String
        let title: String
    }

    private let configs: [TopicConfig] = [
        .init(id: "golden-hour",           title: "Golden Hour"),
        .init(id: "nature",                title: "Nature"),
        .init(id: "animals",               title: "Animals"),
        .init(id: "architecture-interior", title: "Architecture"),
        .init(id: "people",                title: "People")
    ]

    private let remote: TopicRemoteDataSource

    init(remote: TopicRemoteDataSource) {
        self.remote = remote
    }

    func fetchTopics(completion: @escaping (Result<[TopicSection], NetworkError>) -> Void) {
        let group = DispatchGroup()
        let lock = NSLock()

        var sectionsByTitle: [String: TopicSection] = [:]
        var firstError: NetworkError?

        configs.forEach { config in
            group.enter()
            remote.fetchTopicPhotos(topicID: config.id) { result in
                defer { group.leave() }

                lock.lock()
                defer { lock.unlock() }

                switch result {
                case .success(let dtos):
                    let items = dtos.map(UnsplashPhotoMapper.toTopicItem)
                    sectionsByTitle[config.title] = TopicSection(title: config.title, items: items)
                case .failure(let error):
                    if firstError == nil { firstError = error }
                }
            }
        }

        group.notify(queue: .main) {
            let ordered = self.configs.compactMap { sectionsByTitle[$0.title] }

            if ordered.isEmpty, let error = firstError {
                completion(.failure(error))
            } else {
                completion(.success(ordered))
            }
        }
    }
}
