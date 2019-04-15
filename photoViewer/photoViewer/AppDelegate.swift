//
//  AppDelegate.swift

import UIKit
import XCGLogger
import RxSwift

//
var Log: XCGLogger = {
    return XCGLogger.setupSharedLog(identifier: "photosviewer", logFileName: Settings().logFileName)
} ()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!
    private let bag = DisposeBag()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: bag)
        
        return true
    }
}


