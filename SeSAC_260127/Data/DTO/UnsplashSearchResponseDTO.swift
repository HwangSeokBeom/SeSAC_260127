//
//  UnsplashSearchResponseDTO.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import Foundation

struct UnsplashSearchResponseDTO: Decodable {
    let results: [UnsplashPhotoDTO]
}
