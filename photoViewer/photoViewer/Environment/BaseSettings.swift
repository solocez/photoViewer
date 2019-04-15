//
//  BaseSettings.swift

import Foundation
import XCGLogger

protocol BaseSettings {
    
    var appVersion: String { get }
    var logFileName: String { get }
    var logLevel: XCGLogger.Level { get }
    
    var RESTEndpoint: String { get }
    var apiKey: String { get }
    
    var itemsPerPage: Int { get }
    
    var backgroundColor: UIColor { get }
}

extension BaseSettings {
    
    var appVersion: String {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            return "Ver. \(version) (\(build))"
        }
        return ""
    }
    
    var logFileName: String {
        get {
            return "photosviewer.log"
        }
    }
    
    var RESTEndpoint: String {
        get {
            return "http://195.39.233.28:8035"
        }
    }
    
    var apiKey: String {
        get {
            return "23567b218376f79d9415"
        }
    }
    
    var itemsPerPage: Int {
        return 10
    }
    
    var backgroundColor: UIColor {
        return UIColor.init(red: 85 / 255.0, green: 102 / 255.0, blue: 127 / 255.0, alpha: 1.0)
    }
}



