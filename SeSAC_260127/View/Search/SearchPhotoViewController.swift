//
//  SearchPhotoViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit
import SnapKit

final class SearchPhotoViewController: UIViewController, ViewDesignProtocol {
    
    private let viewModel: (SearchPhotoViewModelInput & SearchPhotoViewModelOutput)
    
    init(viewModel: some SearchPhotoViewModelInput & SearchPhotoViewModelOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.placeholder = "키워드 검색"
        bar.returnKeyType = .search
        return bar
    }()
    
    // 색상 필터 컬렉션뷰
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset.right = 90
        return collectionView
    }()
    
    // 사진 그리드 컬렉션뷰
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // 정렬 플로팅 버튼 (필터 컬렉션뷰 위에 떠 있는 형태)
    private let sortButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
  
        var title = AttributedString(" 관련순")
        title.font = .systemFont(ofSize: 14, weight: .medium)
        config.attributedTitle = title
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 검색해보세요."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureHierarchy()
        configureLayout()
        configureActions()
        bindViewModel()
        updateEmptyState()
        viewModel.search(query: "")
        
        // 기본 색상 선택
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let indexPath = IndexPath(item: self.viewModel.selectedColorIndex, section: 0)
            self.filterCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewItemSize()
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
            self.updateEmptyState()
            self.updateSortButtonTitle()
        }
        
        viewModel.onError = { [weak self] message in
            // TODO:
            print(message)
        }
    }
    
    private func updateEmptyState() {
        emptyLabel.isHidden = !viewModel.isEmpty
    }
    
    private func updateSortButtonTitle() {
        var config = sortButton.configuration ?? .plain()
        
        let text: String
        switch viewModel.currentSortOption {
        case .relevance:
            text = " 관련순"
        case .latest:
            text = " 최신순"
        }
        
        var attributed = AttributedString(text)
        attributed.font = .systemFont(ofSize: 14, weight: .medium)
        config.attributedTitle = attributed
        
        sortButton.configuration = config
    }
    
    func configureView() {
        navigationItem.title = "SEARCH PHOTO"
        searchBar.delegate = self
        configureKeyboardDismiss()
    }
    
    func configureHierarchy() {
        
        [ searchBar, filterCollectionView, collectionView, sortButton, emptyLabel].forEach { view.addSubview($0) }
        
    }
    
    func configureLayout() {
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
    
    @objc private func sortButtonTapped() {
        viewModel.toggleSort()
        dismissKeyboard()
    }
    
    private func updateCollectionViewItemSize() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let spacing: CGFloat = 8
        let width = collectionView.bounds.width
        let itemWidth = (width - spacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
    }
}

extension SearchPhotoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return viewModel.items.count
        } else {
            return viewModel.filters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.identifier,
                for: indexPath
            ) as? PhotoCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.items[indexPath.item]
            cell.configure(with: item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FilterCell.identifier,
                for: indexPath
            ) as? FilterCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel.filters[indexPath.item])
            return cell
        }
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        dismissKeyboard()
        if collectionView === filterCollectionView {
            viewModel.selectColor(at: indexPath.item)
            return
        }
        
        if collectionView === self.collectionView {
            guard let photo = viewModel.photo(at: indexPath.item) else {
                return
            }
            let detailVC = DIContainer.shared.makePhotoDetailViewController(photo: photo)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension SearchPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === filterCollectionView {
            let option = viewModel.filters[indexPath.item]
            let font = UIFont.systemFont(ofSize: 14, weight: .medium)
            let textWidth = (option.title as NSString)
                .size(withAttributes: [.font: font]).width
            let width = 10 + 16 + 6 + textWidth + 10
            return CGSize(width: width, height: 32)
        } else {
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                return flowLayout.itemSize
            } else {
                return .zero
            }
        }
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension SearchPhotoViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if searchBar.isFirstResponder { dismissKeyboard() }
        
        guard scrollView === collectionView else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 {
            viewModel.loadNextPage()
        }
    }
}

private extension SearchPhotoViewController {
    
    func configureKeyboardDismiss() {
        collectionView.keyboardDismissMode = .onDrag
        filterCollectionView.keyboardDismissMode = .onDrag
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


