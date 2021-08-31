//
//  DataServiceTest.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift

@testable import FolkApp
class DataServiceTest: XCTestCase {

    private let disposeBag = DisposeBag()
    var dataService: MockPostDataService!
    
    override func setUp() {
        super.setUp()
        dataService = .init()
    }
    
    override func tearDown() {
        super.setUp()
    }
    
    func testDataService_ShouldReturnPost(){
        
        let posts = dataService.fetch(url: kPOSTSURL)
        
      
    }

}
