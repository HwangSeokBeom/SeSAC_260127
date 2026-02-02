//
//  UnsplashEndpoint.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Alamofire

enum UnsplashEndpoint: Endpoint {
    case photoList(page: Int, perPage: Int)
    case searchPhotos(query: String, color: PhotoColor?, sort: PhotoSortOption, page: Int, perPage: Int)
    case photoStatistics(id: String)
    case topicPhotos(id: String, page: Int, perPage: Int)

    var path: String {
        switch self {
        case .photoList:
            return "/photos"
        case .searchPhotos:
            return "/search/photos"
        case .photoStatistics(let id):
            return "/photos/\(id)/statistics"
        case .topicPhotos(let id, _, _):
            return "/topics/\(id)/photos"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .photoList(page, perPage):
            return ["page": page, "per_page": perPage]

        case let .searchPhotos(query, color, sort, page, perPage):
            var params: Parameters = [
                "query": query,
                "page": page,
                "per_page": perPage,
                "order_by": (sort == .latest) ? "latest" : "relevant"
            ]
            if let color { params["color"] = color.rawValue }
            return params

        case .photoStatistics:
            return nil

        case let .topicPhotos(_, page, perPage):
            return ["page": page, "per_page": perPage]
        }
    }
}
