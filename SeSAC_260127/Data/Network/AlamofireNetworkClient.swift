//
//  AlamofireNetworkClient.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation
import Alamofire

final class AlamofireNetworkClient: Networking {

    private let session: Session

    init(session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        return Session(configuration: config)
    }()) {
        self.session = session
    }

    func requestDecodable<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard URL(string: url) != nil else {
            completion(.failure(.invalidURL))
            return
        }

        session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
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
    }
}
