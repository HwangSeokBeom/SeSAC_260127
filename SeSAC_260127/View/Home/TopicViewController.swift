//
//  TopicViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit
import SnapKit

final class TopicViewController: UIViewController {

    private let viewModel: (TopicViewModelInput & TopicViewModelOutput)

    init(viewModel: some TopicViewModelInput & TopicViewModelOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "OUR TOPIC"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = Self.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            TopicCollectionViewCell.self,
            forCellWithReuseIdentifier: TopicCollectionViewCell.identifier
        )
        collectionView.register(
            TopicSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TopicSectionHeaderView.identifier
        )
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
        configureHierarchy()
        configureLayout()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    func configureNavigationBar() {
        navigationItem.title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let image = UIImage(systemName: "person.circle.fill")
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(profileTapped))
        navigationItem.rightBarButtonItem = item
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureHierarchy() {
        [mainTitleLabel, collectionView].forEach { view.addSubview($0) }
    }
    
    func configureLayout() {
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            print("Error:", error)
        }
    }
 
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            // item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .absolute(220)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 0)
            
            // header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(30)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = .zero
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
    @objc func profileTapped() {
        // TODO: 프로필 화면 이동
    }
}

// MARK: - UICollectionViewDataSource

extension TopicViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopicCollectionViewCell.identifier,
            for: indexPath
        ) as! TopicCollectionViewCell
        
        let vm = viewModel.cellViewModel(at: indexPath)   // 🔹 여기 변경
        cell.configure(with: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TopicSectionHeaderView.identifier,
                for: indexPath
              ) as? TopicSectionHeaderView
        else { return UICollectionReusableView() }
        
        let title = viewModel.titleForSection(indexPath.section)   // 🔹 여기 변경
        header.configure(title: title)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 상세화면 push
    }
}
