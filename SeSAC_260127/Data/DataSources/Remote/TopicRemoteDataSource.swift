//
//  TopicRemoteDataSource.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

protocol TopicRemoteDataSource {
    func fetchTopicPhotos(topicID: String, completion: @escaping (Result<[UnsplashPhotoDTO], NetworkError>) -> Void)
}
