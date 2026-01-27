//
//  PhotoCell.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//
import UIKit
import SnapKit

final class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    private var currentItem: PhotoItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(likeBadgeView)
        likeBadgeView.addSubview(starImageView)
        likeBadgeView.addSubview(likeCountLabel)
        contentView.addSubview(favoriteButton)
    }
    
    private func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeBadgeView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(32)
        }
    }
    
    func configure(with item: PhotoItem) {
        currentItem = item
        likeCountLabel.text = "\(item.likeCount)"
        
        if let image = UIImage(named: item.imageName) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        let heartName = item.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartName), for: .normal)
    }
}
