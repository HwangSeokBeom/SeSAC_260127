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
    func toggleFavorite(at index: Int)
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

    // MARK: - State

    private var photos: [Photo] = []

    private(set) var items: [PhotoCellModel] = [] {
        didSet { onUpdate?() }
    }

    private(set) var filters: [FilterCellModel]

    var isEmpty: Bool { items.isEmpty }

    private(set) var currentSortOption: PhotoSortOption = .latest
    private(set) var selectedColorIndex: Int = 0
    private(set) var currentQuery: String = ""

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChange: ((Bool) -> Void)?

    // MARK: - Dependencies

    private let repository: PhotoSearchRepository
    private let likeStore: LikeStoring
    private var likeObserverToken: UUID?

    // MARK: - Pagination

    private var page: Int = 1
    private let pageSize: Int = 20
    private var isLoading: Bool = false
    private var hasMore: Bool = true

    // MARK: - Init / Deinit

    init(repository: PhotoSearchRepository, likeStore: LikeStoring = UserDefaultsManager.shared) {
        self.repository = repository
        self.likeStore = likeStore
        self.filters = PhotoColorFilter.allCases.map { FilterCellModel(filter: $0) }

        self.likeObserverToken = likeStore.addLikeObserver { [weak self] photoID, isLiked in
            self?.applyLikeChange(photoID: photoID, isFavorite: isLiked)
        }
    }

    deinit {
        if let token = likeObserverToken {
            likeStore.removeLikeObserver(token)
        }
    }

    // MARK: - Output Helper

    func photo(at index: Int) -> Photo? {
        guard photos.indices.contains(index) else {
            assertionFailure("photo(at:) index out of range. index: \(index), photos.count: \(photos.count)")
            return nil
        }
        return photos[index]
    }

    // MARK: - Inputs

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

    // MARK: - Private

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
            case .success(let newPhotos):
                self.apply(photos: newPhotos, reset: reset)

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
            self.items = newPhotos.map {
                PhotoCellModel(domain: $0, isFavorite: likeStore.isLiked(photoID: $0.id))
            }
        } else {
            self.photos.append(contentsOf: newPhotos)
            let models = newPhotos.map {
                PhotoCellModel(domain: $0, isFavorite: likeStore.isLiked(photoID: $0.id))
            }
            self.items.append(contentsOf: models)
        }

        if newPhotos.count < pageSize {
            hasMore = false
        } else {
            page += 1
        }
    }

    private func applyLikeChange(photoID: String, isFavorite: Bool) {
        guard let idx = items.firstIndex(where: { $0.id == photoID }) else { return }

        let old = items[idx]
        let updated = PhotoCellModel(
            id: old.id,
            imageURL: old.imageURL,
            likeCountText: old.likeCountText,
            isFavorite: isFavorite
        )

        items[idx] = updated
        // items didSet -> onUpdate -> VC reloadData()
    }
    
    func toggleFavorite(at index: Int) {
        guard photos.indices.contains(index) else { return }

        let photoID = photos[index].id
        _ = likeStore.toggle(photoID: photoID)
        
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
