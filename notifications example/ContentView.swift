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
    @State var upcomingNotifications: [Date] = []
    @State var showingDetail = false
    @State var selection: Int = 2
    @State var subscriptions = Set<AnyCancellable>()
    
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Upcoming notifications")) {
                        ForEach(upcomingNotifications, id: \.self) { date in
                            Text(date.convertDateFormatter())
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
                        let future = futureUpcomingNotifications()
                        
                        future
                            .map() {
                                transFormToTrigger(notificationRequests: $0)
                            }
                            .sink(receiveCompletion: {
                                print("Completed with,", $0)
                            },
                            receiveValue: {
                                print("Recieved \($0) as an array of Dates")
                                upcomingNotifications = $0
                            })
                            .store(in: &subscriptions)
                    }
                    NavigationLink(destination: EditNotificationView()) {
                        Text("Make Notification")
                    }.navigationBarTitle(Text("Master"))
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
