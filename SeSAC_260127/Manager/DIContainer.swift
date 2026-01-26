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
        let apiService: TopicAPIService = DummyTopicAPIService()
        let viewModel = TopicViewModel(service: apiService)
        let vc = TopicViewController(viewModel: viewModel)
        return vc
    }
}
