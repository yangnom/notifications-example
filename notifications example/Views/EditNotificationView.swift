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
    @Environment(\.presentationMode) var presentationMode
    
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
                .onAppear() {
                    selectedDate = request.toDate()
                }
            }
            Button("Save") {
                removeANotificationRequest(request: request)
                setNotification(date: selectedDate)
                self.presentationMode.wrappedValue.dismiss()
                // TODO: setting a date two months gives a date for the next month
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
