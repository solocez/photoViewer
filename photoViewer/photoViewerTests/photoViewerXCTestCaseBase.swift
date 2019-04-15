//
//  XCTestCase.swift

import XCTest
import RxSwift
import XCGLogger

var Log: XCGLogger = {
    return XCGLogger.setupSharedLog(identifier: "pvunittests", logFileName: Settings().logFileName)
} ()

@testable import photoViewer
class PhotoViewerXCTestCaseBase: XCTestCase {
    
    internal let bag = DisposeBag()
    
    // MARK: - AppServices
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}


extension XCTestCase {
    func wait(_ seconds: TimeInterval = 300) -> Error? {
        var err: Error? = nil
        waitForExpectations(timeout: seconds) { (error) -> Void in
            err = error
        }
        return err
    }
}


