//
//  TestingView.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import SwiftUI

struct TestingView: View {
    
    // have to test WHY a static array will update a view, but a an array from a function will NOT update the view
    @State var anArray: [String] = ["First", "Second"]
    
    var body: some View {
        VStack{
            ForEach(anArray, id: \.self) { element in
                Text("Here is a strig: \(element)")
            }
            Button(
                action: {
//                    self.anArray = ["This", "is", "just", "a", "test"]
//                    self.anArray.append(contentsOf: anArrayMadeByAFunction())
                    self.anArray += anArrayMadeByAFunction()
                },
                label: { Text("Change it!") }
            )
        }
    }
}

func anArrayMadeByAFunction() -> [String] {
    return ["This", "was", "made", "from", "a", "function"]
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
