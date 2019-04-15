//
//  AppError.swift
//  Created by Zakhar Sukhanov

import Foundation
import Alamofire

struct AppError: LocalizedError {
    var title: String
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    //
    init(title: String, description: String, code: Int) {
        self.title = title
        self._description = description
        self.code = code
    }
    
    //
    init(_ err: AFError) {
        var codeResult = 54
        if case .responseValidationFailed(let serverError) = err {
            if case .unacceptableStatusCode(let code) = serverError, 401 == code {
                codeResult = code
            }
        }
        self.init(title: R.string.loc.error(), description: err.localizedDescription, code: codeResult)
    }
}

