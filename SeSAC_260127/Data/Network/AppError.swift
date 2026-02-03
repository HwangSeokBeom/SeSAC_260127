//
//  AppError.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/3/26.
//

protocol AppError: Error {
    var userMessage: String { get }
    var debugMessage: String { get }
}
