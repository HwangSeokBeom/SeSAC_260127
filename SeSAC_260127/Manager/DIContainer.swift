//
//  DIContainer.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit

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
    
    func makeSearchPhotoViewController() -> SearchPhotoViewController {
        let service: PhotoSearchServicing = DummyPhotoSearchService()
        let repository: PhotoSearchRepository = DefaultPhotoSearchRepository(service: service)
        let viewModel = SearchPhotoViewModel(repository: repository)
        let vc = SearchPhotoViewController(viewModel: viewModel)
        return vc
    }
}
