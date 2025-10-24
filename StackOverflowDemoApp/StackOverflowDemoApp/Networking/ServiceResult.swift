//
//  ServiceResult.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

struct UnexpectedError: Error { }

enum ServiceResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
