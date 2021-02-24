//
//  EditNotificationView.swift
//  notifications example
//
//  Created by ynom on 1/22/21.
//

import SwiftUI

struct EditNotificationView: View {
    @State var selectedDate: Date = Date()
    @State var selection: Int = 2
    
    var body: some View {
        VStack {
        NavigationView {
                Form {
                    HStack {
                        Spacer()
                        DatePicker(
                            selection: $selectedDate,
                            in: Date()...,
                            displayedComponents: [.hourAndMinute, .date],
                            label: { Text("Choose a notification") }
                        ).labelsHidden()
                        Spacer()
                    }
                    Picker(selection: $selection, label:
                            Text("Notification type"),
                           content: {
                            Text("Picture").tag(0)
                            Text("Actionable").tag(1)
                            Text("Normal").tag(2)
                           })
                        .pickerStyle(SegmentedPickerStyle())
                }
                .navigationBarTitle(Text("Make a notification"))
            }
            Button("Save") {
                var sendableNotification: SendableNotification?
                if selection == 0 {
                    sendableNotification = SendableNotification(time: selectedDate, title: "Picture", subtitle: "worked", picture: true)
                } else if selection == 1 {
                    sendableNotification = SendableNotification(time: selectedDate, title: "Actionable", subtitle: "worked", actionable: true)
                } else {
                    sendableNotification = SendableNotification(time: selectedDate, title: "Normal", subtitle: "worked")
                }
                
                if sendableNotification != nil {
                    setNotificationsWithDates(notifications: [sendableNotification!])
                }

                // needs return from this view to ContentView action here
            }
        }
    }
}

struct EditNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        EditNotificationView()
    }
}
