//
//  SearchPhotoViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation

protocol SearchPhotoViewModelInput: AnyObject {
    func search(query: String)
    func selectColor(at index: Int)
    func toggleSort()
    func loadNextPage()
}

protocol SearchPhotoViewModelOutput: AnyObject {
    var items: [PhotoCellModel] { get }
    var filters: [FilterCellModel] { get }
    var isEmpty: Bool { get }
    var currentSortOption: PhotoSortOption { get }
    var selectedColorIndex: Int { get }
    var currentQuery: String { get }
    
    var onUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingChange: ((Bool) -> Void)? { get set }
    
    func photo(at index: Int) -> Photo?
}

final class SearchPhotoViewModel: SearchPhotoViewModelInput, SearchPhotoViewModelOutput {
    
    private var photos: [Photo] = []
    
    private(set) var items: [PhotoCellModel] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    private(set) var filters: [FilterCellModel]
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    private(set) var currentSortOption: PhotoSortOption = .latest
    private(set) var selectedColorIndex: Int = 0
    private(set) var currentQuery: String = ""
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChange: ((Bool) -> Void)?
     
    private let repository: PhotoSearchRepository
    
    private var page: Int = 1
    private let pageSize: Int = 20
    private var isLoading: Bool = false
    private var hasMore: Bool = true
    
    init(repository: PhotoSearchRepository) {
        self.repository = repository
        self.filters = PhotoColorFilter.allCases.map { FilterCellModel(filter: $0) }
    }
    
    func photo(at index: Int) -> Photo? {
        guard photos.indices.contains(index) else {
            assertionFailure("photo(at:) index out of range. index: \(index), photos.count: \(photos.count)")
            return nil
        }
        return photos[index]
    }
      
    func search(query: String) {
        currentQuery = query
        resetStateForNewRequest()
        request(reset: true)
    }
    
    func selectColor(at index: Int) {
        selectedColorIndex = index
        resetStateForNewRequest()
        request(reset: true)
    }
    
    func toggleSort() {
        currentSortOption = (currentSortOption == .latest) ? .relevance : .latest
        resetStateForNewRequest()
        request(reset: true)
    }
    
    func loadNextPage() {
        guard !isLoading, hasMore else { return }
        request(reset: false)
    }
      
    private func resetStateForNewRequest() {
        page = 1
        hasMore = true
        
        photos = []
        items = []
    }

    private func request(reset: Bool) {
        guard !isLoading else { return }
        isLoading = true
        onLoadingChange?(true)
        
        let color = PhotoColorFilter.allCases[safe: selectedColorIndex]
        let sort = currentSortOption
        
        repository.searchPhotos(
            query: currentQuery,
            color: color,
            sort: sort,
            page: page,
            perPage: pageSize
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            self.onLoadingChange?(false)
            
            switch result {
            case .success(let photos):
                self.apply(photos: photos, reset: reset)
                
            case .failure(let error):
                if reset {
                    self.photos = []
                    self.items = []
                }
                self.onError?("검색 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func apply(photos newPhotos: [Photo], reset: Bool) {
        if reset {
            self.photos = newPhotos
            self.items = newPhotos.map { PhotoCellModel(domain: $0) }
        } else {
            self.photos.append(contentsOf: newPhotos)
            let models = newPhotos.map { PhotoCellModel(domain: $0) }
            self.items.append(contentsOf: models)
        }
        
        // 페이지네이션 상태 업데이트
        if newPhotos.count < pageSize {
            hasMore = false
        } else {
            page += 1
        }
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
