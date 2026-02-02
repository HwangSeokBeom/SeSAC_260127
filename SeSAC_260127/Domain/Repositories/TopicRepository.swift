//
//  TopicRepository.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

protocol TopicRepository {
    func fetchTopics(completion: @escaping (Result<[TopicSection], Error>) -> Void)
}
