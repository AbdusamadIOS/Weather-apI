//
//  BackError.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 21/03/24.
//

import Foundation

enum BackError: Error {
    case unableToComplete
    case invalidResponse
    case invalidData
    case invalidUrl
    case badRequest
    case unauth
    case notFound
    case server
    case postError
}

