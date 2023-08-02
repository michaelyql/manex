//
//  CommandHelpersTests.swift
//  manexTests
//
//  Created by michaelyangqianlong on 12/6/23.
//

import XCTest
@testable import manex

final class CommandHelpersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_IsAngleBetweenRange_Angle010Between350And050_shouldReturnTrue() {
        let is10Between350And050 = CommandUtils.isAngleBetweenRange(angleToCheck: 10, referenceAngle: 200)
        XCTAssertTrue(is10Between350And050, "The method did not correctly return 10 is between 350 and 050")
    }

}
