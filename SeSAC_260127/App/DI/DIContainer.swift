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

    private lazy var likeStorage: LikeStorage = UserDefaultsLikeStorage(
        defaults: .standard,
        likedKey: "liked_photo_ids"
    )

    private lazy var likeRepository: LikeRepository = DefaultLikeRepository(
        storage: likeStorage,
        callbackQueue: .main
    )

    private lazy var likeUseCase: LikeToggleUseCase = DefaultLikeToggleUseCase(
        repository: likeRepository
    )

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

    private func makeSearchPhotosUseCase() -> SearchPhotosUseCase {
        DefaultSearchPhotosUseCase(repository: makePhotoSearchRepository())
    }

    func makeTopicViewController() -> TopicViewController {
        let viewModel = TopicViewModel(repository: makeTopicRepository())
        return TopicViewController(viewModel: viewModel)
    }

    func makeSearchPhotoViewController() -> SearchPhotoViewController {
        let viewModel = SearchPhotoViewModel(
            searchUseCase: makeSearchPhotosUseCase(),   
            likeUseCase: likeUseCase
        )
        return SearchPhotoViewController(viewModel: viewModel)
    }

    func makePhotoDetailViewController(photo: Photo) -> PhotoDetailViewController {
        let viewModel = PhotoDetailViewModel(
            photo: photo,
            repository: makePhotoStatisticsRepository(),
            likeUseCase: likeUseCase
        )
        return PhotoDetailViewController(viewModel: viewModel)
    }
}
