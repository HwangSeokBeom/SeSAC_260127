//
//  NetworkManager.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/27/26.
//

import Foundation
import Alamofire

protocol Networking {
    @discardableResult
    func request<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> DataRequest
}

final class NetworkManager: Networking {
    
    static let shared = NetworkManager()
    
    private let session: Session
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        self.session = Session(configuration: config)
    }
    
    @discardableResult
    func request<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> DataRequest {
        
        guard let _ = URL(string: url) else {
            completion(.failure(.invalidURL))
            // 더 이상 요청 진행 안 함
            return session.request("about:blank")
        }
        
        let request = session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate() // 200~299 status code만 통과
        
        request.responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
                
            case .failure(let afError):
                // 상태코드 기반 에러 먼저 체크
                if let code = response.response?.statusCode,
                   !(200..<300).contains(code) {
                    completion(.failure(.statusCode(code)))
                    return
                }
                
                // 디코딩 에러인지 확인
                if case .responseSerializationFailed(let reason) = afError,
                   case .decodingFailed(let underlying) = reason {
                    completion(.failure(.decoding(underlying)))
                    return
                }
                
                // 그 외 Alamofire 에러 wrapping
                completion(.failure(.underlying(afError)))
            }
        }
        
        return request
    }
}
