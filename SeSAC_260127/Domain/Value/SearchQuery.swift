//
//  SearchQuery.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

import Foundation

struct SearchQuery {
    let value: String

    init(_ raw: String, minLength: Int = 2, maxLength: Int = 40) throws {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            self.value = ""
            return
        }

        guard trimmed.count >= minLength else { throw SearchQueryError.tooShort(min: minLength) }
        guard trimmed.count <= maxLength else { throw SearchQueryError.tooLong(max: maxLength) }

        let pattern = #"^[A-Za-z0-9가-힣\s]+$"#
        guard trimmed.range(of: pattern, options: .regularExpression) != nil else {
            throw SearchQueryError.invalidCharacters
        }

        self.value = trimmed
    }
}
