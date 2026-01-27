//  TopicViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

// TopicViewModel.swift

import UIKit

protocol TopicViewModelInput: AnyObject {
    func viewDidLoad()
    func loadTopics()
}

protocol TopicViewModelOutput: AnyObject {
    var numberOfSections: Int { get }
    
    func titleForSection(_ section: Int) -> String
    func numberOfItems(in section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> TopicCellModel

    var onUpdate: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

final class TopicViewModel: TopicViewModelInput, TopicViewModelOutput {

    private(set) var sections: [TopicSection] = [] {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let service: TopicAPIService
    
    init(service: TopicAPIService = DummyTopicAPIService()) {
        self.service = service
    }

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

    // Output
    var numberOfSections: Int {
        sections.count
    }

    func titleForSection(_ section: Int) -> String {
        sections[section].title
    }

    func numberOfItems(in section: Int) -> Int {
        sections[section].items.count
    }

    func cellViewModel(at indexPath: IndexPath) -> TopicCellModel {
        let item = sections[indexPath.section].items[indexPath.item]
        return TopicCellModel(domain: item)
    }
}

private extension NumberFormatter {
    static let withComma: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
}
