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
}

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
    private(set) var currentSortOption: PhotoSortOption = .latest
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Internal State
    
    private(set) var selectedColorIndex: Int = 0
    private(set) var currentQuery: String = ""
    
    private let repository: PhotoSearchRepository
    
    private var page: Int = 1
    private let pageSize: Int = 20
    private var isLoading: Bool = false
    private var hasMore: Bool = true
    
    init(repository: PhotoSearchRepository) {
        self.repository = repository
        self.filters = PhotoColorFilter.allCases.map {
            FilterCellModel(filter: $0)
        }
    }
    
    // MARK: - Input
    
    func search(query: String) {
        currentQuery = query
        page = 1
        hasMore = true
        items = []              // 새 검색이므로 기존 목록 초기화
        request(reset: true)
    }

    /// 컬러 필터 선택
    func selectColor(at index: Int) {
        selectedColorIndex = index
        guard !currentQuery.isEmpty else {
            // 검색어가 없으면 컬러만 바꿔도 전체 리스트로 재요청
            page = 1
            hasMore = true
            items = []
            request(reset: true)
            return
        }
        // 검색어가 있는 상태면 현재 쿼리로 재검색
        page = 1
        hasMore = true
        items = []
        request(reset: true)
    }
    
    /// 정렬 토글 (오름차순 <-> 내림차순)
    func toggleSort() {
        currentSortOption = (currentSortOption == .latest) ? .relevance : .latest
        guard !currentQuery.isEmpty else {
            // 쿼리 없이 "최신 사진 전체 보기" + 정렬 바꿨을 때
            page = 1
            hasMore = true
            items = []
            request(reset: true)
            return
        }
        // 검색어 있는 상태에서 정렬 변경 시 재검색
        page = 1
        hasMore = true
        items = []
        request(reset: true)
    }
    
    /// 스크롤 끝 근처에서 호출해 줄 "다음 페이지 로드"
    func loadNextPage() {
        guard !isLoading, hasMore else { return }
        request(reset: false)
    }
    
    // MARK: - Private
    
    private func request(reset: Bool) {
        if isLoading { return }
        isLoading = true
        
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
            
            switch result {
            case .success(let photos):
                let models = photos.map(PhotoCellModel.init(domain:))
                
                if reset {
                    self.items = models
                } else {
                    self.items.append(contentsOf: models)
                }
                
                // 받아온 개수가 pageSize보다 작으면 다음 페이지 없음
                if models.count < self.pageSize {
                    self.hasMore = false
                } else {
                    self.page += 1
                }
                
            case .failure(let error):
                if reset {
                    self.items = []
                }
                self.onError?("검색 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Safe Index

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
