//
//  TopicSectionHeaderView.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit
import SnapKit

final class TopicSectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "TopicSectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
