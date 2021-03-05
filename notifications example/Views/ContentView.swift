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
    @State var upcomingNotificationRequests: [UNNotificationRequest] = []
    
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    
                    Section(header: Text("Upcoming notifications")) {
                        ForEach(upcomingNotificationRequests.sorted(), id: \.self) { request in
                            
                            NavigationLink(destination: EditNotificationView(request: request)){
                                Text("\(request.toDate().convertDateFormatter())")
                            }
                            
                        }
                    }

                    
                    Section(header: Text("Notification Testing")) {
                        Button("Erase notifications") {
                            removeAllNotifications()
                            self.upcomingNotificationRequests = notificationRequests()
                        }
                        
                        Button("Set Random Notifications") {
                            setRandomNotifications(numberOfNotifications: 5)
                            self.upcomingNotificationRequests = notificationRequests()
                        }
                        
                        Button("Update Pending Notifications view") {
                            self.upcomingNotificationRequests = notificationRequests()
                        }
                        
                        Button("Set notification without updateView in 10 seconds") {
                            setNotification()
                        }
                        
                    }
                    
                    NavigationLink(destination: TestingView()) {
                        Text("Testing View")
                    }
                }
                .navigationTitle("Notification Testing")
            }
        }
        .onAppear() {
            askForPermission()
            defineCustomActions()
            self.upcomingNotificationRequests = notificationRequests()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
