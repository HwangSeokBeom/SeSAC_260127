//
//  FilterCell.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import UIKit
import SnapKit

final class FilterCell: UICollectionViewCell {
    
    static let identifier = "FilterCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    override var isSelected: Bool {
        didSet { updateSelectionState() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        updateSelectionState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    private func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        containerView.addSubview(titleLabel)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        colorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateSelectionState() {
        if isSelected {
            containerView.backgroundColor = .black
            titleLabel.textColor = .white
            colorView.layer.borderWidth = 1
            colorView.layer.borderColor = UIColor.white.cgColor
        } else {
            containerView.backgroundColor = .systemGray6
            titleLabel.textColor = .label
            colorView.layer.borderWidth = 0
        }
    }
    
    func configure(with viewModel: FilterCellModel) {
        titleLabel.text = viewModel.title
        colorView.backgroundColor = viewModel.filter.uiColor
    }
}
