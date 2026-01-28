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
    
    /// 디테일 화면 진입 시 사용할 도메인 모델
    func photo(at index: Int) -> Photo
}

final class SearchPhotoViewModel: SearchPhotoViewModelInput, SearchPhotoViewModelOutput {
    
    // MARK: - Output State
    
    /// 도메인 레이어 데이터
    private var photos: [Photo] = []
    
    /// 프레젠테이션 레이어 데이터 (컬렉션뷰 셀용)
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
    
    // MARK: - Domain Access
    
    func photo(at index: Int) -> Photo {
        guard photos.indices.contains(index) else {
            assertionFailure("photo(at:) index out of range. index: \(index), photos.count: \(photos.count)")
            return photos.last ?? Photo(
                id: "",
                imageURL: nil,
                likeCount: 0,
                isFavorite: false,
                width: 0,
                height: 0,
                userName: "",
                userProfileImageURL: nil,
                createdAt: nil
            )
        }
        return photos[index]
    }
    
    // MARK: - Input
    
    func search(query: String) {
        currentQuery = query
        page = 1
        hasMore = true
    
        photos = []
        items = []
        
        request(reset: true)
    }
    
    /// 컬러 필터 선택
    func selectColor(at index: Int) {
        selectedColorIndex = index
        
        page = 1
        hasMore = true
        
        photos = []
        items = []
        
        request(reset: true)
    }
    
    /// 정렬 토글 (최신 <-> 관련도)
    func toggleSort() {
        currentSortOption = (currentSortOption == .latest) ? .relevance : .latest
        
        page = 1
        hasMore = true
        
        photos = []
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
    
    /// 도메인 + 프레젠테이션 동기화
    private func apply(photos newPhotos: [Photo], reset: Bool) {
        if reset {
            // ✅ 새 검색이면 통째로 교체
            self.photos = newPhotos
            self.items = newPhotos.map { PhotoCellModel(domain: $0) }
        } else {
            // ✅ 페이지네이션이면 append
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

// MARK: - Safe Index

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
