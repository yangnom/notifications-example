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
                        ForEach(upcomingNotificationRequests, id: \.self) { request in
                            
                            NavigationLink(destination: EditNotificationView(request: request)){
                                Text("\(request.toDate().convertDateFormatter())")
                            }
                            
                        }
                    }

                    
                    Section(header: Text("Notification Testing")) {
                        Button("Erase notifications") {
                            removeAllNotifications()
                            
                            pendingNotificationRequests() { requests in
                                self.upcomingNotificationRequests = requests
                            }
                            
                        }
                        
                        Button("Set Random Notifications") {
                            
                            setRandomNotifications(numberOfNotifications: 5)
                            
                            pendingNotificationRequests() { requests in
                                self.upcomingNotificationRequests = requests
                            }
                        }
                        
                        Button("Update Pending Notifications view") {
                            pendingNotificationRequests() { requests in
                                self.upcomingNotificationRequests = requests
                            }
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
            pendingNotificationRequests() { requests in
                self.upcomingNotificationRequests = requests
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
