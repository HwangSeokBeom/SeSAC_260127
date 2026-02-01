//
//  PhotoCell.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    var onTapFavorite: (() -> Void)?
    
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
    
    private var currentModel: PhotoCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
        likeCountLabel.text = nil
        currentModel = nil
        onTapFavorite = nil
        
        let heartImage = UIImage(systemName: "heart")
        favoriteButton.setImage(heartImage, for: .normal)
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
    
    private func configureActions() {
          favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
      }
    
    func configure(with viewModel: PhotoCellModel) {
        currentModel = viewModel
        
        likeCountLabel.text = viewModel.likeCountText
        
        if let url = viewModel.imageURL {
            photoImageView.kf.setImage(with: url)
        } else {
            photoImageView.image = nil
        }
        
        let heartName = viewModel.isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: heartName)
        favoriteButton.setImage(image, for: .normal)
        updateFavoriteUI(isFavorite: viewModel.isFavorite)
    }
    
    
    private func updateFavoriteUI(isFavorite: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let name = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: name, withConfiguration: config), for: .normal)
    }

    @objc private func didTapFavorite() {
        onTapFavorite?()
    }
}
