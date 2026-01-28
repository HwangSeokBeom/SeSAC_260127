//  TopicViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import Foundation

// MARK: - Protocols

protocol TopicViewModelInput: AnyObject {
    func viewDidLoad()
    func loadTopics()
}

protocol TopicViewModelOutput: AnyObject {
    var numberOfSections: Int { get }
    
    func titleForSection(_ section: Int) -> String
    func numberOfItems(in section: Int) -> Int
    func cellViewModel(section: Int, item: Int) -> TopicCellModel 
    var onUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

// MARK: - ViewModel

final class TopicViewModel: TopicViewModelInput, TopicViewModelOutput {

    // MARK: - State
    
    private(set) var sections: [TopicSection] = [] {
        didSet { onUpdate?() }
    }

    // MARK: - Output Callbacks
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Dependencies
    
    private let repository: TopicRepository
    
    init(repository: TopicRepository) {
        self.repository = repository
    }

    // MARK: - Input
    
    func viewDidLoad() {
        loadTopics()
    }

    func loadTopics() {
        repository.fetchTopics { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let sections):
                self.sections = sections
            case .failure(let error):
                self.sections = []
                self.onError?("토픽 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Output Helpers
    
    var numberOfSections: Int {
        sections.count
    }

    func titleForSection(_ section: Int) -> String {
        sections[section].title
    }

    func numberOfItems(in section: Int) -> Int {
        sections[section].items.count
    }

    func cellViewModel(section: Int, item: Int) -> TopicCellModel {
        let item = sections[section].items[item]
        return TopicCellModel(domain: item)
    }
}
