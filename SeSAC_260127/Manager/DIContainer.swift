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

    // 메인 Topic 탭
    func makeTopicViewController() -> TopicViewController {
        let service: TopicAPIService = UnsplashTopicAPIService(
            apiKey: APIKey.unsplash,
            network: NetworkManager.shared
        )
        let repository: TopicRepository = DefaultTopicRepository(service: service)
        let viewModel = TopicViewModel(repository: repository)
        let vc = TopicViewController(viewModel: viewModel)
        return vc
    }
    
    // 검색 탭 
    func makeSearchPhotoViewController() -> SearchPhotoViewController {
        let service: PhotoSearchServicing = UnsplashPhotoSearchService(
            apiKey: APIKey.unsplash,
            network: NetworkManager.shared
        )
        let repository: PhotoSearchRepository = DefaultPhotoSearchRepository(service: service)
        let viewModel = SearchPhotoViewModel(repository: repository)
        let vc = SearchPhotoViewController(viewModel: viewModel)
        return vc
    }
}
