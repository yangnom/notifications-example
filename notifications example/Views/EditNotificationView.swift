//
//  EditNotificationView.swift
//  notifications example
//
//  Created by ynom on 1/22/21.
//

import SwiftUI

struct EditNotificationView: View {
    var request: UNNotificationRequest
    //TODO: start with the input Date
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
                removeANotificationRequest(request: request)
                setNotification(date: selectedDate)
                // go back to ContentView()
            }
        }
    }
}

struct EditNotificationView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditNotificationView(request: Calendar.current.dateComponents([.day, .hour, .minute, .second], from: randomDate())
                                .trigger()
                                .notificationRequest(content: notificationContent())
        )
    }
}
