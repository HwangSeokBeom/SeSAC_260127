//
//  TopicCollectionViewCell.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

//  TopicCollectionViewCell.swift

import UIKit
import SnapKit
import Kingfisher

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
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardImageView.kf.cancelDownloadTask()
        cardImageView.image = nil
        likeLabel.text = nil
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
    
    private func configureView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .secondarySystemBackground
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
   
    func configure(with model: TopicCellModel) {
        likeLabel.text = model.likeCountText
        
        if let url = model.imageURL {
            cardImageView.kf.setImage(with: url)
        } else {
            cardImageView.image = nil
            cardImageView.backgroundColor = .systemGray5
        }
    }
}
