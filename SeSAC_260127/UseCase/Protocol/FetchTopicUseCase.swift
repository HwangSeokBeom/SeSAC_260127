//
//  FetchTopicUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

protocol FetchTopicUseCasing {
    func fetchTopics(completion: @escaping (Result<[TopicSection], Error>) -> Void)
}
