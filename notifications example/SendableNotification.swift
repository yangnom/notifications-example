//
//  SendableNotification.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import Foundation
import NotificationCenter
import Combine

func setNotification(date: Date = Date().addingTimeInterval(10),
                     title: String = "Title",
                     subtitle: String = "Subtitle",
                     sound: UNNotificationSound = UNNotificationSound.default,
                     type: NotificationTypes = .normal) {
    
    let content = notificationContent(title: title, subtitle: subtitle, sound: sound, type: .normal)

    let notificationRequest = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        .trigger()
        .notificationRequest(content: content)
    
    UNUserNotificationCenter.current().add(notificationRequest)
}

func notificationContent(title: String = "title",
                         subtitle: String = "subtitle",
                         sound: UNNotificationSound = UNNotificationSound.default,
                         type: NotificationTypes = .normal) -> UNMutableNotificationContent {

    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.sound = sound
    
    if type == .action { content.categoryIdentifier = "MEETING_INVITATION" }
    if type == .picture {
        let fileURL: URL = Bundle.main.url(forResource: "test", withExtension: "jpg")!
        let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
        content.attachments = [attachement!]
    }
    
    return content
}

extension UNNotificationTrigger {
    func notificationRequest(content: UNNotificationContent) -> UNNotificationRequest {
        UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent(title: "Title", subtitle: "Subtitle"), trigger: self)
    }
}

extension DateComponents {
    func trigger(repeats: Bool = false) -> UNNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: self, repeats: repeats)
    }
}


func setRandomNotifications(numberOfNotifications: Int = 1) {
    for _ in 1...numberOfNotifications {
        setNotification(date: Date().addingTimeInterval(Double.random(in: 1...9999999)))
    }
}


//MARK: Helpers

// need to properly test, or ask, if this always serially
func pendingNotificationRequests(closure: @escaping ([UNNotificationRequest]) -> ()) {
    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
        closure(requests)
    })
}

func removeAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
func randomDate() -> Date {
    Date().addingTimeInterval(Double.random(in: 0...90000))
}

func randomDateComponents() -> DateComponents {
    DateComponents(hour: Int.random(in: 0...24), minute: Int.random(in: 0...60))
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
    
    func toDateComponents() -> DateComponents{
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self)
    }
}

extension UNNotificationRequest {
    func toDate() ->  Date {
        let realTrigger = self.trigger as? UNCalendarNotificationTrigger
        return (realTrigger?.nextTriggerDate())!
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

// MARK: Setting Notifications
enum NotificationTypes {
    case action
    case picture
    case normal
}
