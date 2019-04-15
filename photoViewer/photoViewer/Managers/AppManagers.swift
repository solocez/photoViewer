//
//  AppManagers.swift

import Foundation

//
protocol AppManagers: class {
    var rest: RESTManager { get }
}

//
final class AppManagersImpl: AppManagers {
    private lazy var _rest: RESTManager = RESTManagerImpl()
    
    var rest: RESTManager {
        get {
            return _rest
        }
    }
}
