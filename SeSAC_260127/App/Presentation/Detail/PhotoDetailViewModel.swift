//
//  PhotoDetailViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import Foundation

protocol PhotoDetailViewModelInput: AnyObject {
    func load()
    func selectChartType(_ type: PhotoDetailViewModel.ChartType)
    func toggleLike()
}

protocol PhotoDetailViewModelOutput: AnyObject {
    var photo: Photo { get }

    var sizeText: String { get }
    var viewsText: String { get }
    var downloadsText: String { get }

    var authorNameText: String { get }
    var authorProfileURL: URL? { get }
    var createdAtText: String { get }

    var selectedChartType: PhotoDetailViewModel.ChartType { get }
    var chartData: [DailyStat] { get }

    var onUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingChange: ((Bool) -> Void)? { get set }

    var isLiked: Bool { get }
}

final class PhotoDetailViewModel: PhotoDetailViewModelInput, PhotoDetailViewModelOutput {

    enum ChartType {
        case views
        case downloads
    }

    let photo: Photo

    private(set) var sizeText: String = ""
    private(set) var viewsText: String = "-"
    private(set) var downloadsText: String = "-"

    private(set) var authorNameText: String = "-"
    private(set) var authorProfileURL: URL?
    private(set) var createdAtText: String = "-"

    private(set) var selectedChartType: ChartType = .views
    private(set) var chartData: [DailyStat] = []

    private(set) var isLiked: Bool = false

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChange: ((Bool) -> Void)?

    private let repository: PhotoStatisticsRepository
    private let likeRepository: LikeRepository

    private var statistics: PhotoStatistics?
    private var likeObserverToken: UUID?

    init(
        photo: Photo,
        repository: PhotoStatisticsRepository,
        likeRepository: LikeRepository
    ) {
        self.photo = photo
        self.repository = repository
        self.likeRepository = likeRepository

        sizeText = "\(photo.width) x \(photo.height)"
        authorNameText = photo.userName
        authorProfileURL = photo.userProfileImageURL
        createdAtText = Self.formatDate(photo.createdAt)

        isLiked = likeRepository.isLiked(photoID: photo.id)

        likeObserverToken = likeRepository.addObserver { [weak self] changedID, liked in
            guard let self, changedID == self.photo.id else { return }
            self.isLiked = liked
            self.onUpdate?()
        }
    }

    deinit {
        if let token = likeObserverToken {
            likeRepository.removeObserver(token)
        }
    }

    private static func formatDate(_ date: Date?) -> String {
        guard let date else { return "-" }
        return DisplayFormatter.photoCreatedDate(date)
    }

    func load() {
        onLoadingChange?(true)

        repository.fetchStatistics(
            photoID: photo.id,
            width: photo.width,
            height: photo.height
        ) { [weak self] result in
            guard let self else { return }
            self.onLoadingChange?(false)

            switch result {
            case .success(let stats):
                self.statistics = stats
                self.selectedChartType = .views
                self.sizeText = "\(stats.width) x \(stats.height)"
                self.viewsText = Self.formatNumber(stats.totalViews)
                self.downloadsText = Self.formatNumber(stats.totalDownloads)
                self.updateChartData()
                self.onUpdate?()

            case .failure(let error):
                self.onError?("통계 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }

    func selectChartType(_ type: ChartType) {
        selectedChartType = type
        updateChartData()
        onUpdate?()
    }

    func toggleLike() {
        isLiked = likeRepository.toggle(photoID: photo.id)
        onUpdate?()
    }

    private func updateChartData() {
        guard let stats = statistics else { return }
        switch selectedChartType {
        case .views:
            chartData = stats.viewsHistory
        case .downloads:
            chartData = stats.downloadsHistory
        }
    }

    private static func formatNumber(_ value: Int) -> String {
        DisplayFormatter.decimal(value)
    }
}
