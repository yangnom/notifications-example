//
//  TestingView.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import SwiftUI
import Combine

struct TestingView: View {
    
    // have to test WHY a static array will update a view, but a an array from a function will NOT update the view
    @State var arrayOfDates: [Date] = [Date(), Date().addingTimeInterval(2000)]
    @State var subscriptions = Set<AnyCancellable>()

    
    var body: some View {
        VStack {
            Form {
                Button("Passes [UNNotificationRequest]") {
                    
                }

                
            }
        }
    }
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
