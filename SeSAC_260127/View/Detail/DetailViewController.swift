//
//  DetailViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoDetailViewController: UIViewController, ViewDesignProtocol {
    
    private let viewModel: (PhotoDetailViewModelInput & PhotoDetailViewModelOutput)
    
    init(viewModel: some PhotoDetailViewModelInput & PhotoDetailViewModelOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let authorImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .tertiarySystemFill
        return iv
    }()
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "크기"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let viewsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회수"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let downloadsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "다운로드"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let sizeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let viewsValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let downloadsValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
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
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let downloadsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다운로드", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureHierarchy()
        configureLayout()
        configureActions()
        bindViewModel()
        applyInitialData()
        
        viewModel.load()
    }
}

extension PhotoDetailViewController {
    
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "사진 상세"
        
        let backButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }
    
    func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [authorImageView, authorNameLabel, createdAtLabel,
         mainImageView, infoTitleLabel, sizeTitleLabel, viewsTitleLabel,
         downloadsTitleLabel, sizeValueLabel, viewsValueLabel,
         downloadsValueLabel, chartTitleLabel, viewsButton,
         downloadsButton, chartView]
            .forEach { contentView.addSubview($0) }
        
        view.addSubview(activityIndicator)
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        authorImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(36)
        }
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(authorImageView)
            make.leading.equalTo(authorImageView.snp.trailing).offset(8)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorNameLabel)
            make.top.equalTo(authorNameLabel.snp.bottom).offset(2)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(authorImageView.snp.bottom).offset(16)
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
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(viewsButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-32)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
    
extension PhotoDetailViewController {
    
    func configureActions() {
        viewsButton.addTarget(self, action: #selector(didTapViews), for: .touchUpInside)
        downloadsButton.addTarget(self, action: #selector(didTapDownloads), for: .touchUpInside)
    }
    
    func bindViewModel() {
        viewModel.onLoadingChange = { [weak self] loading in
            loading ? self?.activityIndicator.startAnimating()
                    : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.updateStatistics()
                self.updateChartButtons()
                self.updateChartView()
            }
        }

        viewModel.onLoadingChange = { [weak self] loading in
            DispatchQueue.main.async {
                loading ? self?.activityIndicator.startAnimating()
                        : self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.onError = { message in
            print("Detail Error:", message)
        }
    }
}

extension PhotoDetailViewController {
    
    private func applyInitialData() {
        authorNameLabel.text = viewModel.authorNameText
        createdAtLabel.text = viewModel.createdAtText
        
        if let url = viewModel.authorProfileURL {
            authorImageView.kf.setImage(with: url)
        }
        
        if let url = viewModel.photo.imageURL {
            mainImageView.kf.setImage(with: url)
        }
        
        sizeValueLabel.text = viewModel.sizeText
        viewsValueLabel.text = viewModel.viewsText
        downloadsValueLabel.text = viewModel.downloadsText
        
        updateChartButtons()
        updateChartView()
    }
    
    private func updateStatistics() {
        sizeValueLabel.text = viewModel.sizeText
        viewsValueLabel.text = viewModel.viewsText
        downloadsValueLabel.text = viewModel.downloadsText
    }
    
    private func updateChartButtons() {
        let selected = viewModel.selectedChartType
        let style: (UIButton, Bool) -> Void = { btn, selected in
            if selected {
                btn.backgroundColor = .label
                btn.setTitleColor(.systemBackground, for: .normal)
            } else {
                btn.backgroundColor = .systemGray5
                btn.setTitleColor(.label, for: .normal)
            }
        }
        style(viewsButton, selected == .views)
        style(downloadsButton, selected == .downloads)
    }
    
    private func updateChartView() {
        chartView.render(viewModel.chartData)
    }
}

extension PhotoDetailViewController {
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapViews() {
        viewModel.selectChartType(.views)
    }
    
    @objc private func didTapDownloads() {
        viewModel.selectChartType(.downloads)
    }
}
