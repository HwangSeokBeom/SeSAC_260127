//
//  DIContainer.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

final class DIContainer {

    static let shared = DIContainer()
    private init() {}

    // 모듈 단위로 factory 제공
    func makeTopicViewController() -> TopicViewController {
        let api = DummyTopicAPIService()
        let repo = DefaultTopicRepository(api: api)
        let useCase = FetchTopicUseCase(repository: repo)
        let viewModel = TopicViewModel(fetchTopicUseCase: useCase)
        let vc = TopicViewController(viewModel: viewModel)
        return vc
    }
}
