//
//  ProfileViewModel.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

protocol ProfileViewModelInput: AnyObject {
    func updateYear(_ text: String?)
    func updateMonth(_ text: String?)
    func updateDay(_ text: String?)
    func submit()
}

protocol ProfileViewModelOutput: AnyObject {
    var buttonTitle: String { get }
    var onUpdate: (() -> Void)? { get set }
}

final class ProfileViewModel: ProfileViewModelInput, ProfileViewModelOutput {

    private let validateUseCase: BirthDateValidateUseCase

    private var yearText: String?
    private var monthText: String?
    private var dayText: String?

    private(set) var buttonTitle: String = "생년월일 확인" {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?

    init(validateUseCase: BirthDateValidateUseCase) {
        self.validateUseCase = validateUseCase
    }

    func updateYear(_ text: String?) { yearText = text }
    func updateMonth(_ text: String?) { monthText = text }
    func updateDay(_ text: String?) { dayText = text }

    func submit() {
        do {
            let birth = try validateUseCase.execute(
                yearText: yearText,
                monthText: monthText,
                dayText: dayText
            )
            buttonTitle = "생년월일 기입이 성공했습니다  (\(birth.year)-\(birth.month)-\(birth.day))"
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "알 수 없는 오류가 발생했습니다."
            buttonTitle = "실패 \(message)"
        }
    }
}
