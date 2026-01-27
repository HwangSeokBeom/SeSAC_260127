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
    // 컬렉션뷰(사진 그리드)에 바인딩할 데이터
    var items: [PhotoCellModel] { get }
    
    // 상단 색상 필터 컬렉션뷰에 바인딩할 데이터
    var filters: [FilterCellModel] { get }
    
    // 검색 결과가 비어 있는지 여부 (emptyLabel 숨김/표시용)
    var isEmpty: Bool { get }
    
    // 현재 정렬 옵션 (관련순 / 최신순)
    var currentSortOption: PhotoSortOption { get }
    
    // 선택된 색상 필터 인덱스 (기본 선택, 재선택용)
    var selectedColorIndex: Int { get }
    
    // 데이터 변경 시 VC에서 reload 등을 트리거하기 위한 콜백
    var onUpdate: (() -> Void)? { get set }
    
    // 에러 메시지를 VC로 전달하기 위한 콜백
    var onError: ((String) -> Void)? { get set }
}

final class SearchPhotoViewModel: SearchPhotoViewModelInput, SearchPhotoViewModelOutput {
    
    // Output
    private(set) var items: [PhotoCellModel] = []
    private(set) var filters: [FilterCellModel]
    private(set) var isEmpty: Bool = true
    private(set) var currentSortOption: PhotoSortOption = .relevance
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // State
    private(set) var selectedColorIndex: Int = 0
    private(set) var currentQuery: String = ""
    
    private let repository: PhotoSearchRepository
    
    init(repository: PhotoSearchRepository) {
        self.repository = repository
        self.filters = PhotoColorFilter.allCases.map {
            FilterCellModel(filter: $0)
        }
    }
    
    func search(query: String = "") {
        currentQuery = query
        
        let color = PhotoColorFilter.allCases[safe: selectedColorIndex]
        let sort = currentSortOption
        
        repository.searchPhotos(query: query, color: color, sort: sort) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let photos):
                self.items = photos.map(PhotoCellModel.init(domain:))
                self.isEmpty = self.items.isEmpty
                self.onUpdate?()
            case .failure(let error):
                self.items = []
                self.isEmpty = true
                self.onUpdate?()
                self.onError?("검색 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
    func selectColor(at index: Int) {
        selectedColorIndex = index
        search(query: currentQuery)
    }
    
    func toggleSort() {
        currentSortOption = (currentSortOption == .relevance) ? .latest : .relevance
        search(query: currentQuery)
    }
}


private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
