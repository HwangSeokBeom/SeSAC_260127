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
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: endpoint.urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        session.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers
        )
        .responseDecodable(of: T.self) { response in

            if let code = response.response?.statusCode, !(200...299).contains(code) {
                completion(.failure(.statusCode(code)))
                return
            }

            switch response.result {
            case .success(let value):
                completion(.success(value))

            case .failure(let afError):

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
