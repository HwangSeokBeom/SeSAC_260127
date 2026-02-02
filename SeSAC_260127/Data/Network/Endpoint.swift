//
//  Endpoint.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Alamofire

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    var baseURL: String { "https://api.unsplash.com" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { URLEncoding.default }

    var urlString: String { baseURL + path }
}
