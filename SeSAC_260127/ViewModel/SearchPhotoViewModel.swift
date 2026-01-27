//
//  SearchPhotoViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

// SearchPhotoViewModel.swift

import Foundation

protocol SearchPhotoViewModelInput: AnyObject {
    func search(query: String)
    func selectColor(at index: Int)
    func toggleSort()
}

protocol SearchPhotoViewModelOutput: AnyObject {
    var items: [PhotoCellModel] { get }
    var filters: [FilterCellModel] { get }
    var isEmpty: Bool { get }
    var currentSortOption: PhotoSortOption { get }
    var selectedColorIndex: Int { get }
    
    var onUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

// MARK: - ViewModel

final class SearchPhotoViewModel: SearchPhotoViewModelInput, SearchPhotoViewModelOutput {
    
    // MARK: - Output State
    
    private(set) var items: [PhotoCellModel] = [] {
        didSet {
            isEmpty = items.isEmpty
            onUpdate?()
        }
    }
    
    private(set) var filters: [FilterCellModel]
    private(set) var isEmpty: Bool = true
    private(set) var currentSortOption: PhotoSortOption = .relevance
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Internal State
    
    private(set) var selectedColorIndex: Int = 0
    private(set) var currentQuery: String = ""
    
    private let repository: PhotoSearchRepository
    
    init(repository: PhotoSearchRepository) {
        self.repository = repository
        self.filters = PhotoColorFilter.allCases.map {
            FilterCellModel(filter: $0)
        }
    }
    
    // MARK: - Input
    
    func search(query: String) {
        currentQuery = query
        
        let color = PhotoColorFilter.allCases[safe: selectedColorIndex]
        let sort = currentSortOption
        
        repository.searchPhotos(query: query, color: color, sort: sort) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let photos):
                self.items = photos.map(PhotoCellModel.init(domain:))
            case .failure(let error):
                self.items = []
                self.onError?("검색 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func selectColor(at index: Int) {
        selectedColorIndex = index
        guard !currentQuery.isEmpty else { return }
        search(query: currentQuery)
    }
    
    func toggleSort() {
        currentSortOption = (currentSortOption == .relevance) ? .latest : .relevance
        guard !currentQuery.isEmpty else { return }
        search(query: currentQuery)
    }
}

// MARK: - Safe Index

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
