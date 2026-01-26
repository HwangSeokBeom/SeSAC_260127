//
//  TopicCollectionViewCell.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit
import SnapKit

final class TopicCollectionViewCell: UICollectionViewCell {

    static let identifier = "TopicCollectionViewCell"

    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        return view
    }()

    private let badgeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        contentView.addSubview(cardImageView)
        cardImageView.addSubview(dimView)
        cardImageView.addSubview(badgeContainer)
        badgeContainer.addSubview(starImageView)
        badgeContainer.addSubview(likeLabel)
    }

    private func configureLayout() {
        cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        badgeContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(30)
        }

        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }

        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with viewModel: TopicItemViewModel) {
        cardImageView.image = UIImage(named: viewModel.imageName)
        likeLabel.text = viewModel.likeCountText
    }
}
