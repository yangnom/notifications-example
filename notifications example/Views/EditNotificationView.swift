//
//  EditNotificationView.swift
//  notifications example
//
//  Created by ynom on 1/22/21.
//

import SwiftUI

struct EditNotificationView: View {
    @State var selectedDate: Date
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
                //erase previous notification
                // set new notification
                setNotification(date: selectedDate)
            }
        }
    }
}

struct EditNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        EditNotificationView(selectedDate: Date())
    }
}
