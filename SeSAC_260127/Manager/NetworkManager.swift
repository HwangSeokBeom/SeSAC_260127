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

        guard URL(string: url) != nil else {
            completion(.failure(.invalidURL))
            return session.request("about:blank")
        }

        let request = session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate(statusCode: 200..<300) 

        request.responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))

            case .failure(let afError):

                if let code = response.response?.statusCode {
                    completion(.failure(.statusCode(code)))
                    return
                }

                if case .responseSerializationFailed(let reason) = afError,
                   case .decodingFailed(let underlying) = reason {
                    completion(.failure(.decoding(underlying)))
                    return
                }

                if let urlError = afError.underlyingError as? URLError {
                    completion(.failure(.underlying(urlError)))
                    return
                }

                completion(.failure(.underlying(afError)))
            }
        }

        return request
    }
}
