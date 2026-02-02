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

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        self.session = Session(configuration: config)
    }

    func requestDecodable<T: Decodable>(
        _ type: T.Type,
        endpoint: Endpoint,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard URL(string: endpoint.urlString) != nil else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        session.request(
            endpoint.urlString,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))

            case .failure(let afError):
                if let code = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(code)))
                    return
                }

                if case .responseSerializationFailed(let reason) = afError,
                   case .decodingFailed(let underlying) = reason {
                    completion(.failure(NetworkError.decoding(underlying)))
                    return
                }

                if let urlError = afError.underlyingError as? URLError {
                    completion(.failure(NetworkError.underlying(urlError)))
                    return
                }

                completion(.failure(NetworkError.underlying(afError)))
            }
        }
    }
}
