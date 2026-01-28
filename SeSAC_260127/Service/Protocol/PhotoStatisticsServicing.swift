//
//  PhotoStatisticsServicing.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/28/26.
//

import Foundation

protocol PhotoStatisticsServicing {
    func fetchStatistics(
        photoID: String,
        width: Int,
        height: Int,
        completion: @escaping (Result<PhotoStatistics, Error>) -> Void
    )
}
