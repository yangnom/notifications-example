//
//  ContentView.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import SwiftUI
import NotificationCenter

struct ContentView: View {
    
    @State var selectedDate: Date = Date()
    @State var upcomingNotifications: [Date] = []
    @State var showingDetail = false
    @State var selection: Int = 2
    
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Upcoming notifications")) {
                        ForEach(upcomingNotifications, id: \.self) { date in
                            Text(date.convertDateFormatter())
                        }
                    }
                    Section(header: Text("Customize notification")) {
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
                                Text("Picker Name")
                               , content: {
                                Text("Picture").tag(0)
                                Text("Actionable").tag(1)
                                Text("Value 3").tag(2)
                                Text("Value 4").tag(3)
                               })
                        Button("Make a notification") {
                            defer {
                                upcomingNotifications = Array(numberOfPendingNotifications().sorted(by: { $0.compare($1) == .orderedAscending }).prefix(3))
                            }
                            if selection == 1 {
                                let notificationDate = SendableNotification(time: selectedDate, title: "Actionable!", subtitle: "actionable notification!", actionable: true)
                                setNotificationsWithDates(notifications: [notificationDate])
                            } else {
                                let notificationDate = SendableNotification(time: selectedDate, title: "Normal notification!", subtitle: "regular boring!")
                                setNotificationsWithDates(notifications: [notificationDate])
                            }
                                print("Notification made")
                        }
                    }
                    Button("Pull up the sheet") {
                        self.showingDetail = true
                    }
                    Button("Erase notifications") {
                        let userNotificationCenter = UNUserNotificationCenter.current()
                        userNotificationCenter.removeAllPendingNotificationRequests()
                        self.upcomingNotifications = []
                    }
                    Button("updatePendingView") {
                        upcomingNotifications = Array(numberOfPendingNotifications().sorted(by: { $0.compare($1) == .orderedAscending }).prefix(3))
                    }
                }
                .navigationTitle("Notification Testing")
            }
            .sheet(isPresented: $showingDetail){
                TestingView()
            }
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            defineCustomActions()
        })
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(upcomingNotifications: [Date(), Date().addingTimeInterval(3000)])
    }
}
