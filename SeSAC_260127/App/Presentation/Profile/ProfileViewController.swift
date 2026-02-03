//
//  ProfileViewController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//


import UIKit
import SnapKit

final class ProfileViewController: UIViewController, ViewDesignProtocol {

    private let viewModel: (ProfileViewModelInput & ProfileViewModelOutput)

    init(viewModel: some ProfileViewModelInput & ProfileViewModelOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일 입력"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let yearField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "년 (YYYY)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private let monthField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "월 (MM)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private let dayField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "일 (DD)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("생년월일 확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        return button
    }()

    private let helperLabel: UILabel = {
        let label = UILabel()
        label.text = "버튼을 누르면 성공/실패 메시지가 버튼 타이틀에 표시됩니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureHierarchy()
        configureLayout()
        configureActions()
        bindViewModel()
        applyInitialData()
    }
}

extension ProfileViewController {

    func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"

        let backButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    func configureHierarchy() {
        [titleLabel, yearField, monthField, dayField, helperLabel, submitButton]
            .forEach { view.addSubview($0) }
    }

    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        yearField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        monthField.snp.makeConstraints { make in
            make.top.equalTo(yearField.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(yearField)
        }

        dayField.snp.makeConstraints { make in
            make.top.equalTo(monthField.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(yearField)
        }

        helperLabel.snp.makeConstraints { make in
            make.top.equalTo(dayField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(yearField)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(helperLabel.snp.bottom).offset(18)
            make.leading.trailing.equalTo(yearField)
            make.height.equalTo(48)
        }
    }
}

extension ProfileViewController {

    func configureActions() {
        yearField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        monthField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        dayField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.submitButton.setTitle(self.viewModel.buttonTitle, for: .normal)
                self.applyButtonStyle(title: self.viewModel.buttonTitle)
            }
        }
    }

    private func applyInitialData() {
        submitButton.setTitle(viewModel.buttonTitle, for: .normal)
        applyButtonStyle(title: viewModel.buttonTitle)
    }

    private func applyButtonStyle(title: String) {
   
        if title.contains("성공") {
            submitButton.backgroundColor = .label
            submitButton.setTitleColor(.systemBackground, for: .normal)
        } else if title.contains("실패") {
            submitButton.backgroundColor = .systemGray5
            submitButton.setTitleColor(.label, for: .normal)
        } else {
            submitButton.backgroundColor = .systemGray6
            submitButton.setTitleColor(.label, for: .normal)
        }
    }

    @objc private func textChanged(_ sender: UITextField) {
        if sender === yearField { viewModel.updateYear(sender.text) }
        else if sender === monthField { viewModel.updateMonth(sender.text) }
        else if sender === dayField { viewModel.updateDay(sender.text) }
    }

    @objc private func didTapSubmit() {
        viewModel.submit()
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
