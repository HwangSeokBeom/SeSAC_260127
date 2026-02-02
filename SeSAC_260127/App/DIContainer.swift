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


    private lazy var network: Networking = AlamofireNetworkClient()
    private let unsplashKey: String = APIKey.unsplash

    private lazy var likeRepository: LikeRepository = UserDefaultsLikeRepository()

    private func makeTopicRemoteDataSource() -> TopicRemoteDataSource {
        UnsplashTopicRemoteDataSource(apiKey: unsplashKey, network: network)
    }

    private func makePhotoSearchRemoteDataSource() -> PhotoSearchRemoteDataSource {
        UnsplashPhotoRemoteDataSource(apiKey: unsplashKey, network: network)
    }

    private func makePhotoStatisticsRemoteDataSource() -> PhotoStatisticsRemoteDataSource {
        UnsplashPhotoStatisticsRemoteDataSource(apiKey: unsplashKey, network: network)
    }

    private func makeTopicRepository() -> TopicRepository {
        DefaultTopicRepository(remote: makeTopicRemoteDataSource())
    }

    private func makePhotoSearchRepository() -> PhotoSearchRepository {
        DefaultPhotoSearchRepository(remote: makePhotoSearchRemoteDataSource())
    }

    private func makePhotoStatisticsRepository() -> PhotoStatisticsRepository {
        DefaultPhotoStatisticsRepository(remote: makePhotoStatisticsRemoteDataSource())
    }

    func makeTopicViewController() -> TopicViewController {
        let viewModel = TopicViewModel(repository: makeTopicRepository())
        return TopicViewController(viewModel: viewModel)
    }

    func makeSearchPhotoViewController() -> SearchPhotoViewController {
        let viewModel = SearchPhotoViewModel(
            repository: makePhotoSearchRepository(),
            likeRepository: likeRepository
        )
        return SearchPhotoViewController(viewModel: viewModel)
    }

    func makePhotoDetailViewController(photo: Photo) -> PhotoDetailViewController {
        let viewModel = PhotoDetailViewModel(
            photo: photo,
            repository: makePhotoStatisticsRepository(),
            likeRepository: likeRepository
        )
        return PhotoDetailViewController(viewModel: viewModel)
    }
}
