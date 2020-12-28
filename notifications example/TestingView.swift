//
//  TestingView.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import SwiftUI

struct TestingView: View {
    
    // have to test WHY a static array will update a view, but a an array from a function will NOT update the view
    @State var anArray: [String] = ["First", "Second"]
    
    var body: some View {
        Button("Print Categories") {
            printCategories()
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

func printCategories() {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationCategories{ setOfCategories in
        for category in setOfCategories {
            print(category)
            print("The category actions are: \(category.actions.description)")
            print("Category summary format: \(category.categorySummaryFormat.description)")
        }
        print("There are \(setOfCategories.count) categories")
    }
}


struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
