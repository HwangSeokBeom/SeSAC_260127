//  TopicViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit

struct TopicItemViewModel {
    let title: String
    let imageName: String
    let likeCountText: String
}

final class TopicViewModel {

    // MARK: - Output
    private(set) var sections: [TopicSection] = [] {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?

    // MARK: - Service
    private let service: TopicAPIService

    /// 기본값으로 DummyTopicAPIService 주입
    init(service: TopicAPIService = DummyTopicAPIService()) {
        self.service = service
    }

    // MARK: - Input
    func viewDidLoad() {
        loadTopics()
    }

    func loadTopics() {
        service.requestTopicSections { [weak self] result in
            switch result {
            case .success(let sections):
                self?.sections = sections
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }

    // MARK: - Helpers for VC (DataSource용)

    var numberOfSections: Int {
        sections.count
    }

    func sectionTitle(at index: Int) -> String {
        sections[index].title
    }

    func numberOfItems(in section: Int) -> Int {
        sections[section].items.count
    }

    func itemViewModel(at indexPath: IndexPath) -> TopicItemViewModel {
        let item = sections[indexPath.section].items[indexPath.item]
        return TopicItemViewModel(
            title: item.title,
            imageName: item.imageName,
            likeCountText: NumberFormatter.withComma.string(from: item.likeCount as NSNumber) ?? "\(item.likeCount)"
        )
    }
}

private extension NumberFormatter {
    static let withComma: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
}
