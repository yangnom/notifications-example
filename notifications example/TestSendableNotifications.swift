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

// -------- For setting notificatins ---------------
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

    
// ------- For reading upcoming notificatinos -----------
    
    func test_returnsAll_Notifications() {
        // given
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllPendingNotificationRequests()
        let numberOfSNs = Int.random(in: 1...9)
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: numberOfSNs)
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)
        var arrayOfDates: [Date] = []
        
        //when
        arrayOfDates = numberOfPendingNotifications()
        
        //then
        XCTAssertEqual(numberOfSNs, arrayOfDates.count)
    }
    
    func test_getPNRs_isAsync() {
        // given
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllPendingNotificationRequests()
        let numberOfSNs = Int.random(in: 1...9)
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: numberOfSNs)
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)
        var arrayOfDates: [Date] = []
                
        // when
        userNotificationCenter.getPendingNotificationRequests { requests in
                arrayOfDates = []
                for request in requests {
                    let realTrigger = request.trigger as? UNCalendarNotificationTrigger
                    arrayOfDates.append((realTrigger?.nextTriggerDate())!)
                }
        }
        
        // then
        XCTAssertNotEqual(numberOfSNs, arrayOfDates.count)
    }

// ----- test if removingAllPendingNotifications doesn't erase notifications
    // - set after it was called but before it finishes
    func test_removingAllPNs_wontErase_futureNotifications() {
        
    }
}
