//
//  Untitled.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//
import Foundation

final class DummyTopicAPIService: TopicAPIService {

    func requestTopicSections(completion: @escaping (Result<[TopicSection], Error>) -> Void) {
      
        let sections: [TopicSection] = [
            TopicSection(
                title: "골든 아워",
                items: [
                    TopicItem(title: "Golden Hour 1", imageName: "golden1", likeCount: 1234),
                    TopicItem(title: "Golden Hour 2", imageName: "golden2", likeCount: 35235)
                ]
            ),
            TopicSection(
                title: "비즈니스 및 업무",
                items: [
                    TopicItem(title: "Business 1", imageName: "business1", likeCount: 876),
                    TopicItem(title: "Business 2", imageName: "business2", likeCount: 4242)
                ]
            ),
            TopicSection(
                title: "건축 및 인테리어",
                items: [
                    TopicItem(title: "Interior 1", imageName: "interior1", likeCount: 7475),
                    TopicItem(title: "Interior 2", imageName: "interior2", likeCount: 2200)
                ]
            )
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(sections))
        }
    }
}
