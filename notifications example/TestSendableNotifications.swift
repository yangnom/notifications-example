//
//  TestSendableNotifications.swift
//  notifications exampleTests
//
//  Created by ynom on 12/22/20.
//

import XCTest
import Combine

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
    
    // the fact that getting pending notification requests is indeed async
    // and runs in a non-serially way shows that my method does create serialness
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
    
    // ---- test removing notifications ---------
    func test_removingAllPNs_wontErase_futureNotifications() {
        // given
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllPendingNotificationRequests()
        let numberOfSNs = Int.random(in: 1...9)
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: numberOfSNs)
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)
        var arrayOfDates: [Date] = []
        
        // when
        userNotificationCenter.removeAllPendingNotificationRequests()
        setNotificationsWithDates(notifications: randomArrayOfSendableNotifications(numberOfNotifications: 1))
        arrayOfDates = numberOfPendingNotifications()
        
        // then
        XCTAssertEqual(arrayOfDates.count, 1)
    }
    
    
    // ---- combine_arrayOfPendingNotifications test -----------
    
    func test_futurePublisherExecutes() {
        // given
        let currentUNuserNotificationCenter = UNUserNotificationCenter.current()
        currentUNuserNotificationCenter.removeAllPendingNotificationRequests()
        sleep(1)
        
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: 6)
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)
        
        var arrayOfNotificationRequests: [UNNotificationRequest] = []
        let publisher: Just<[UNNotificationRequest]>
        
        // when
        let futureAsyncPublisher = Future<[UNNotificationRequest], Never> { promise in
            currentUNuserNotificationCenter.getPendingNotificationRequests { requests in
                promise(.success(requests))
                arrayOfNotificationRequests = requests
                XCTAssertEqual(arrayOfNotificationRequests.count, 6)
            }
        }.eraseToAnyPublisher()
        
        
    }
    
    func test_combineArrayOfPendingNotifications() {
        // given
        let currentUNuserNotificationCenter = UNUserNotificationCenter.current()
        currentUNuserNotificationCenter.removeAllPendingNotificationRequests()
        sleep(1)
        
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: 6)
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)
        
        var arrayOfNotificationRequests: [UNNotificationRequest] = []
        let publisher: Just<[UNNotificationRequest]>
        
        // when
        let futureAsyncPublisher = Future<[UNNotificationRequest], Never> { promise in
            currentUNuserNotificationCenter.getPendingNotificationRequests { requests in
                promise(.success(requests))
                arrayOfNotificationRequests = requests
                XCTAssertEqual(arrayOfNotificationRequests.count, 6)
            }
        }
        .eraseToAnyPublisher()
        
        
    }
    
    func test_futureIncrement {
        // given
        let currentUNuserNotificationCenter = UNUserNotificationCenter.current()
        currentUNuserNotificationCenter.removeAllPendingNotificationRequests()
        sleep(1)
        
        let arrayOfSendableNotifications = randomArrayOfSendableNotifications(numberOfNotifications: 6)
        setNotificationsWithDates(notifications: arrayOfSendableNotifications)
        
        // when
        futureIncrement()
        
        // then
    }
}
