//
//  BirthDateValidateUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

protocol BirthDateValidateUseCase {
    func execute(yearText: String?, monthText: String?, dayText: String?) throws -> BirthDateValue
}
