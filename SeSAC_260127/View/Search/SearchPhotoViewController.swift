//
//  SearchPhotoViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit
import SnapKit

final class SearchPhotoViewController: UIViewController {
    
    // MARK: - UI
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.placeholder = "키워드 검색"
        bar.returnKeyType = .search
        return bar
    }()
    
    // 색상 필터 컬렉션뷰 (가로 스크롤)
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = false
        // 정렬 버튼이 오른쪽 위에 겹치니까 여유 공간
        cv.contentInset.right = 90
        return cv
    }()
    
    // 사진 그리드 컬렉션뷰
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 정렬 플로팅 버튼 (필터 컬렉션뷰 위에 떠 있는 형태)
    private let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" 관련순", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 12)
        
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    
    // MARK: - Data
    
    private var items: [PhotoItem] = []  // 처음엔 빈 상태 ( "사진을 검색해보세요" 상태 )
    
    private let filters: [FilterOption] = [
        FilterOption(title: "블랙",  color: .black),
        FilterOption(title: "화이트", color: .white),
        FilterOption(title: "옐로우", color: .systemYellow),
        FilterOption(title: "레드",   color: .systemRed),
        FilterOption(title: "오렌지", color: .systemOrange),
        FilterOption(title: "그린",   color: .systemGreen),
        FilterOption(title: "블루",   color: .systemBlue),
        FilterOption(title: "네이비", color: .systemIndigo),
        FilterOption(title: "퍼플",   color: .systemPurple)
    ]
    
    private var selectedFilterIndex: Int = 0   // 기본: 블랙
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 검색해보세요."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private var isLatestSort = false {
        didSet {
            let title = isLatestSort ? " 최신순" : " 관련순"
            sortButton.setTitle(title, for: .normal)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureHierarchy()
        configureLayout()
        configureActions()
        updateEmptyState()
        
        // 기본 선택 상태 셀
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let indexPath = IndexPath(item: self.selectedFilterIndex, section: 0)
            self.filterCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewItemSize()
    }
    
    // MARK: - Setup
    
    private func configureView() {
        navigationItem.title = "SEARCH PHOTO"
    }
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(filterCollectionView)
        view.addSubview(collectionView)
        view.addSubview(sortButton)
        view.addSubview(emptyLabel)
    }
    
    private func configureLayout() {
        let safe = view.safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safe)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        // 정렬 플로팅 버튼: 필터 라인 오른쪽에 떠 있게
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(filterCollectionView.snp.centerY)
            make.trailing.equalTo(safe).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(safe).offset(-8)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
    }
    
    private func configureActions() {
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    private func updateEmptyState() {
        emptyLabel.isHidden = !items.isEmpty
    }
    
    // MARK: - Actions (정렬 버튼)
    
    @objc private func sortButtonTapped() {
        isLatestSort.toggle()
        print(isLatestSort ? "최신순 정렬" : "관련순 정렬")
        // TODO: items 정렬 후 reload
        // collectionView.reloadData()
    }
    
    // MARK: - Layout Helper (사진 셀 크기)
    
    private func updateCollectionViewItemSize() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let spacing: CGFloat = 8
        let width = collectionView.bounds.width
        let itemWidth = (width - spacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchPhotoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return items.count
        } else {
            return filters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionView {
            // 사진 셀
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.identifier,
                for: indexPath
            ) as? PhotoCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: items[indexPath.item])
            return cell
        } else {
            // 색상 필터 셀
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FilterCell.identifier,
                for: indexPath
            ) as? FilterCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: filters[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SearchPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView === filterCollectionView {
            selectedFilterIndex = indexPath.item
            print("필터 선택:", filters[indexPath.item].title)
            // TODO: 색상 필터에 따라 items 필터링 후 reload
        } else {
            // 사진 셀 선택 시 동작
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout (필터 셀 깨짐 해결)

extension SearchPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 색상 필터 컬렉션뷰 셀 사이즈 계산
        if collectionView === filterCollectionView {
            let option = filters[indexPath.item]
            let font = UIFont.systemFont(ofSize: 14, weight: .medium)
            let textWidth = (option.title as NSString)
                .size(withAttributes: [.font: font]).width
            // 좌우 inset(10+10) + 색상 동그라미(16) + 텍스트 좌우 여유(6)
            let width = 10 + 16 + 6 + textWidth + 10
            return CGSize(width: width, height: 32)
        }
        return .zero   // 사진 컬렉션뷰는 updateCollectionViewItemSize에서 설정
    }
}
