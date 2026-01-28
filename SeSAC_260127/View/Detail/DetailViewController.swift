//
//  DetailViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import UIKit
import SnapKit

final class PhotoDetailViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .tertiarySystemFill
        return iv
    }()
    
    // MARK: Info Section
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let sizeTitleLabel = makeInfoKeyLabel("크기")
    private let viewsTitleLabel = makeInfoKeyLabel("조회수")
    private let downloadsTitleLabel = makeInfoKeyLabel("다운로드")
    
    private let sizeValueLabel = makeInfoValueLabel()
    private let viewsValueLabel = makeInfoValueLabel()
    private let downloadsValueLabel = makeInfoValueLabel()
    
    // MARK: Chart Section
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "차트"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let viewsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("조회", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let downloadsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다운로드", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationItem()
        configureHierarchy()
        configureLayout()
        configureData()
    }
    
    // MARK: - Navigation
    
    private func setupNavigationItem() {
        // 제목은 필요하면 수정
        navigationItem.title = "사진 상세"
        
        // 커스텀 백 버튼
        let backButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // 스와이프 뒤로가기 제스처 유지
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // 오른쪽에 좋아요 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup UI

extension PhotoDetailViewController {
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(mainImageView)
        
        contentView.addSubview(infoTitleLabel)
        contentView.addSubview(sizeTitleLabel)
        contentView.addSubview(viewsTitleLabel)
        contentView.addSubview(downloadsTitleLabel)
        contentView.addSubview(sizeValueLabel)
        contentView.addSubview(viewsValueLabel)
        contentView.addSubview(downloadsValueLabel)
        
        contentView.addSubview(chartTitleLabel)
        contentView.addSubview(viewsButton)
        contentView.addSubview(downloadsButton)
        contentView.addSubview(chartView)
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(2)
            make.leading.equalTo(usernameLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        sizeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(infoTitleLabel)
        }
        
        viewsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(sizeTitleLabel)
        }
        
        downloadsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(viewsTitleLabel)
        }
        
        sizeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sizeTitleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        viewsValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewsTitleLabel)
            make.trailing.equalTo(sizeValueLabel)
        }
        
        downloadsValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(downloadsTitleLabel)
            make.trailing.equalTo(sizeValueLabel)
        }
        
        chartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(downloadsTitleLabel.snp.bottom).offset(28)
            make.leading.equalTo(infoTitleLabel)
        }
        
        viewsButton.snp.makeConstraints { make in
            make.top.equalTo(chartTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(chartTitleLabel)
            make.height.equalTo(28)
            make.width.equalTo(52)
        }
        
        downloadsButton.snp.makeConstraints { make in
            make.centerY.equalTo(viewsButton)
            make.leading.equalTo(viewsButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(84)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(viewsButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    private func configureData() {
        // 테스트용 더미 데이터
        usernameLabel.text = "Brayden Prato"
        dateLabel.text = "2024년 7월 3일 게시됨"
        sizeValueLabel.text = "3098 x 3872"
        viewsValueLabel.text = "1,548,623"
        downloadsValueLabel.text = "388,996"
        
        // mainImageView / profileImageView는 나중에 실제 이미지로 교체
        mainImageView.image = UIImage(named: "sample_photo") // 없는 경우 그냥 배경색만 보임
    }
}

// MARK: - Helper

private func makeInfoKeyLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = .label
    return label
}

private func makeInfoValueLabel() -> UILabel {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .secondaryLabel
    label.textAlignment = .right
    return label
}
