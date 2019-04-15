//
//  photoViewerTests.swift


import XCTest
@testable import photoViewer

extension photoViewerTests: AppManagersConsumer { }
class photoViewerTests: PhotoViewerXCTestCaseBase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testAuthToken() {
//        let exp = expectation(description: "token")
//
//        appManagers.rest.auth().subscribe(onSuccess: { (token) in
//            defer { exp.fulfill() }
//            XCTAssert(!token.isEmpty)
//            Log.debug("TOKEN: \(token)")
//        }) { (err) in
//            defer { exp.fulfill() }
//            Log.error("\(err)")
//            XCTFail()
//            }.disposed(by: bag)
//        XCTAssert(wait() == nil)
//    }
    
    func testPhoto() {
        let exp = expectation(description: "photos")
        
        appManagers.rest.images(page: 1).subscribe(onSuccess: { (photos) in
            defer { exp.fulfill() }
            XCTAssert(!photos.pictures.isEmpty)
        }) { (err) in
            defer { exp.fulfill() }
            Log.error("\(err)")
            XCTFail()
            }.disposed(by: bag)
        XCTAssert(wait() == nil)
    }
    
    func testDetails() {
        let exp = expectation(description: "details")
        
        appManagers.rest.imageDetails(id: "b501a808c6fe71aef59c").subscribe(onSuccess: { (details) in
            defer { exp.fulfill() }
            Log.debug("\(details)")
        }) { (err) in
            defer { exp.fulfill() }
            Log.error("\(err)")
            XCTFail()
            }.disposed(by: bag)
        XCTAssert(wait() == nil)
    }
}
