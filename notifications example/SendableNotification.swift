//
//  SendableNotification.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import Foundation
import NotificationCenter
import Combine


// MARK: Setting Notifications
enum NotificationTypes {
    case action
    case picture
    case normal
}

struct SendableNotification {
    let dateComponents: DateComponents
    let content: UNMutableNotificationContent
    let actionable: Bool
    let picture: Bool
    
    init(time: Date, title: String, subtitle: String, actionable: Bool = false, picture: Bool = false, sound: UNNotificationSound = UNNotificationSound.default) {
        
        dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: time)
        
        self.actionable = actionable
        self.picture = picture
        // give the notification content
        content = UNMutableNotificationContent()
        // make a unit test for this
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
    }
}

func notificationContent(title: String = "title",
                         subtitle: String = "subtitle",
                         sound: UNNotificationSound = UNNotificationSound.default) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.sound = sound
    return content
}

extension UNMutableNotificationContent {
    func trigger(dateComponents: DateComponents) -> UNCalendarNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
}

extension UNNotificationRequest {
    func toDate() ->  Date {
        let realTrigger = self.trigger as? UNCalendarNotificationTrigger
        return (realTrigger?.nextTriggerDate())!
    }
}

extension Date {
    func toDateComponents() -> DateComponents{
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self)
    }
}

func setANotificationNew(title: String = "title",
                         subtitle: String = "subtitle",
                         date: Date = Date().addingTimeInterval(10)) {
    let content = notificationContent(title: title, subtitle: subtitle)
    let trigger = content.trigger(dateComponents: date.toDateComponents())
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) {error in
        if let error = error {
            fatalError("There is an error: \(error.localizedDescription)")
        }
    }
}

// need to properly test, or ask, if this always serially
func notificationRequests(closure: @escaping ([UNNotificationRequest]) -> ()) {
    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//        promise(.success(requests))
        closure(requests)
    })
}

func askForPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}

func removeAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
}

func notificationContent(title: String, subtitle: String, type: NotificationTypes = .normal) -> UNMutableNotificationContent {

    let content = UNMutableNotificationContent()
    content.title = "This is title"
    content.subtitle = "This is subtitle"
    content.sound = UNNotificationSound.default
    
    if type == .action { content.categoryIdentifier = "MEETING_INVITATION" }
    if type == .picture {
        let fileURL: URL = Bundle.main.url(forResource: "test", withExtension: "jpg")!
        let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
        content.attachments = [attachement!]
    }
    
    return content
}

func setNotification(date: Date) {
    let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
    
    // setup the trigger and request
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent(title: "Title", subtitle: "Subtitle"), trigger: trigger)
    UNUserNotificationCenter.current().add(request) {error in
        if let error = error {
            fatalError("There is an error: \(error.localizedDescription)")
        }
    }
}

func defineCustomActions() {
    // Define the custom actions.
    let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                                            title: "Accept",
                                            options: UNNotificationActionOptions(rawValue: 0))
    let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
                                             title: "Decline",
                                             options: UNNotificationActionOptions(rawValue: 0))
    // Define the notification type
    let meetingInviteCategory =
        UNNotificationCategory(identifier: "MEETING_INVITATION",
                               actions: [acceptAction, declineAction],
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "",
                               options: .customDismissAction)
    // Register the notification type.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.setNotificationCategories([meetingInviteCategory])
    
}




// MARK: Randoms for testing
func randomNotificationRequest() -> UNNotificationRequest {
    // setup the trigger and request
    let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: randomDate())
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent(title: "Random title", subtitle: "Random subtitle"), trigger: trigger)
    return request
}

func randomDate() -> Date {
    let randomSeconds = Double.random(in: 0...90000)
    let date = Date().addingTimeInterval(randomSeconds)
    return date
}

func randomDateComponents() -> DateComponents {
    let dateComponents = DateComponents(hour: Int.random(in: 0...24), minute: Int.random(in: 0...60))
    return dateComponents
}

func randomNotificationContent() -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    // make a unit test for this
    content.title = "Title is: \(UUID().uuidString)"
    content.subtitle = "subtitle is: \(UUID().uuidString)"
    content.sound = UNNotificationSound.default
    
    return UNMutableNotificationContent()
}

func randomArrayOfSendableNotifications(numberOfNotifications: Int) -> [SendableNotification] {
    var sendableArray: [SendableNotification] = []
    
    for _ in 1...numberOfNotifications {
        sendableArray.append(SendableNotification(time: randomDate(), title: UUID().uuidString, subtitle: UUID().uuidString))
    }
    return sendableArray
}

func arrayOfRandomDates() -> [Date] {
    var dateArray: [Date] = []
    
    for _ in 1...10  {
        dateArray.append(randomDate())
    }
    return dateArray
}

// MARK: Extensions
extension Date {
    func convertDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        
        //        dateFormatter.dateFormat = "dd h:mm a"
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone?
        let timeStamp = dateFormatter.string(from: self)
        
        return timeStamp
    }
}

func setNotificationsWithDates(notifications: [SendableNotification])  {
    
    for notification in notifications {
        
        if notification.actionable == true {
            notification.content.categoryIdentifier = "MEETING_INVITATION"
        } else if notification.picture == true {
            let fileURL: URL = Bundle.main.url(forResource: "test", withExtension: "jpg")! //  your disk file url, support image, audio, movie
            
            let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
            notification.content.attachments = [attachement!]
        }
        
        // setup the trigger and request
        let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification.content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {
                fatalError("There is an error: \(error.localizedDescription)")
            }
        }
        
        print("Notification Date: \(String(describing: trigger.nextTriggerDate()?.description))")
    }
    
}


//TODO: Look over this function and figure out semaPhores
//func numberOfPendingNotifications() -> [Date] {
//
//    let currentUNuserNotificationCenter = UNUserNotificationCenter.current()
//    var arrayOfDates: [Date] = []
//    let sema = DispatchSemaphore(value: 0)
//
//    currentUNuserNotificationCenter.getPendingNotificationRequests { requests in
//        // if there are no notifications the for loop won't run, so let's update the view
//        if requests.count == 0 {
//            print("No notifications")
//            arrayOfDates = []
//        }
//        arrayOfDates = []
//        for request in requests {
//            let realTrigger = request.trigger as? UNCalendarNotificationTrigger
//            arrayOfDates.append((realTrigger?.nextTriggerDate())!)
//            print("array of dates is \(arrayOfDates)")
//        }
//        sema.signal()
//    }
//    sema.wait()
//
//    return arrayOfDates
//}
