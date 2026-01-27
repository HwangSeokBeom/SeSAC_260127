//
//  NetworkError.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case statusCode(Int)
    case decoding(Error)
    case underlying(Error)
    case noData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL 입니다."
        case .statusCode(let code):
            return "네트워크 오류 (status code: \(code))"
        case .decoding(let error):
            return "데이터 디코딩 실패: \(error.localizedDescription)"
        case .underlying(let error):
            return "네트워크 통신 중 오류 발생: \(error.localizedDescription)"
        case .noData:
            return "서버에서 데이터를 받지 못했습니다."
        }
    }
}
