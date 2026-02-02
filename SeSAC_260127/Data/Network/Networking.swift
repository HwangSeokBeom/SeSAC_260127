//
//  Networking.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation
import Alamofire

protocol Networking {
    func requestDecodable<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
