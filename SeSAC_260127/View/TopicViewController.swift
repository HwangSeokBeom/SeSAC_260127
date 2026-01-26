//
//  TopicViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit
import SnapKit

final class TopicViewController: UIViewController {

    private let viewModel: TopicViewModel

    // 상단 OUR TOPIC
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "OUR TOPIC"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()

    // 상단 우측 프로필 버튼
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = Self.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            TopicCollectionViewCell.self,
            forCellWithReuseIdentifier: TopicCollectionViewCell.reuseIdentifier
        )
        cv.register(
            TopicSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TopicSectionHeaderView.reuseIdentifier
        )
        return cv
    }()

    // MARK: - Init

    init(viewModel: TopicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureHierarchy()
        configureLayout()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }

    private func configureHierarchy() {
        view.addSubview(mainTitleLabel)
        view.addSubview(profileButton)
        view.addSubview(collectionView)
    }

    private func configureLayout() {
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(20)
        }

        profileButton.snp.makeConstraints { make in
            make.centerY.equalTo(mainTitleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }

        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }

    // MARK: - Layout

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
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TopicViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopicCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TopicCollectionViewCell else { return UICollectionViewCell() }

        let itemVM = viewModel.itemViewModel(at: indexPath)
        cell.configure(with: itemVM)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TopicSectionHeaderView.reuseIdentifier,
                for: indexPath
              ) as? TopicSectionHeaderView
        else { return UICollectionReusableView() }

        header.configure(title: viewModel.sectionTitle(at: indexPath.section))
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 상세화면 push
    }
}
