//
//  TestSendableNotifications.swift
//  notifications exampleTests
//
//  Created by ynom on 12/22/20.
//

import XCTest
@testable import notifications_example

class TestSendableNotifications: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_NotificationsGetSet() {
        // given
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllPendingNotificationRequests()
        let numberOfSNs = Int.random(in: 1...9)
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: numberOfSNs)
        
        //when
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)

        let arrayOfNotificationDates = numberOfPendingNotifications()
        
        
        //then
        XCTAssertEqual(arrayOfNotificationDates.count, numberOfSNs)
    }
}
