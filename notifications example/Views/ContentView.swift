//
//  ContentView.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import SwiftUI
import NotificationCenter
import Combine

struct ContentView: View {
    
    @State var selectedDate: Date = Date()
    @State var upcomingNotificationDates: [Date] = []
    @State var selection: Int = 2
    @State var subscriptions = Set<AnyCancellable>()
    
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    
                    Section(header: Text("Upcoming notifications")) {
                        ForEach(upcomingNotificationDates, id: \.self) { date in
                            Text(date.convertDateFormatter())
                        }
                    }
                    
                    Section(header: Text("Old Style")) {
                        Button("Erase notifications") {
                             removeAllNotifications()
                            
                            notificationRequests() { requests in
                                self.upcomingNotificationDates = requests.map { $0.toDate() }
                            }
                            
                        }
                        
                        Button("Set Random Notifications") {
                            let arrayOfRandomNotifications = randomArrayOfSendableNotifications(numberOfNotifications: 5)
                            setNotificationsWithDates(notifications: arrayOfRandomNotifications)
                            
                            notificationRequests() { requests in
                                self.upcomingNotificationDates = requests.map { $0.toDate() }
                            }
                        }
          
                        Button("Update Pending Notifications view") {
                            notificationRequests() { requests in
                                self.upcomingNotificationDates = requests.map { $0.toDate() }
                            }
                        }
                        
//                        Button("Set notification without updateView") {
//                            setNotification(date: Date().addingTimeInterval(80000))
//                        }
                        
                    }
                    
                    
                    NavigationLink(destination: TestingView()) {
                        Text("Testing View")
                    }
                    
                    NavigationLink(destination: EditNotificationView()) {
                        Text("Make Notification")
                    }.navigationBarTitle(Text("Notifications"))
                }
                .navigationTitle("Notification Testing")
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
            
            let future = futureUpcomingNotificationRequests()
            
            future
                .map() {
                    notificationRequestsToDates(notificationRequests: $0)
                }
                .sink(receiveCompletion: {
                    print("Completed with,", $0)
                },
                receiveValue: {
                    print("Recieved \($0) as an array of Dates")
                    upcomingNotificationDates = $0
                })
                .store(in: &subscriptions)
        })
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(upcomingNotificationDates: [Date(), Date().addingTimeInterval(3000)])
    }
}
