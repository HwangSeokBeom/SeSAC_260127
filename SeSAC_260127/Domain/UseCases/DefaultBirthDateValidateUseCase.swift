//
//  DefaultBirthDateValidateUseCase.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

final class DefaultBirthDateValidateUseCase: BirthDateValidateUseCase {

    init() {}

    func execute(yearText: String?, monthText: String?, dayText: String?) throws -> BirthDateValue {

        let yearString = (yearText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let monthString = (monthText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dayString = (dayText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !yearString.isEmpty else { throw BirthDateError.empty(field: .year) }
        guard !monthString.isEmpty else { throw BirthDateError.empty(field: .month) }
        guard !dayString.isEmpty else { throw BirthDateError.empty(field: .day) }

        guard let year = Int(yearString) else { throw BirthDateError.notNumber(field: .year) }
        guard let month = Int(monthString) else { throw BirthDateError.notNumber(field: .month) }
        guard let day = Int(dayString) else { throw BirthDateError.notNumber(field: .day) }

        let currentYear = Calendar.current.component(.year, from: Date())
        let minYear = 1900
        let maxYear = currentYear

        guard (minYear...maxYear).contains(year) else {
            throw BirthDateError.yearOutOfRange(min: minYear, max: maxYear)
        }

        guard (1...12).contains(month) else {
            throw BirthDateError.monthOutOfRange
        }

        let maxDay = Self.daysInMonth(year: year, month: month)
        guard (1...maxDay).contains(day) else {
            throw BirthDateError.dayOutOfRange(maxDay: maxDay)
        }

        return BirthDateValue(year: year, month: month, day: day)
    }

    private static func daysInMonth(year: Int, month: Int) -> Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month

        let calendar = Calendar.current
        let date = calendar.date(from: comps) ?? Date()
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 31
    }
}
