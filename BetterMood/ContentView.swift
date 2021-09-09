//
//  ContentView.swift
//  BetterMood
//
//  Created by Yosri on 5/9/2021.
//

import SwiftUI
import Firebase

// Main View
struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
        if self.status {
            Button(action: {
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }){
                Text(UserDefaults.standard.value(forKey: "fname") as? String ?? "John")
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        } else {
            LoginHome().onAppear {
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "signed_in")
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

// Home Page
struct LoginHome: View {
    @State var index = 0
    @State var AlertVisibilty = false
    @State var loading = false
    @State var title = ""
    @State var message = ""
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                Image("logo_text")
                    .resizable()
                    .frame(width: 797 / 4, height: 488 / 4)
                    .padding(.bottom, 50)
                    .padding(.top, 90)
                    .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                ZStack(alignment: .top){
                    Login(index: self.$index, loading: self.$loading, AlertVisibilty: self.$AlertVisibilty, title: self.$title, message: self.$message)
                        .zIndex(self.index == 0 ? 1 : 0)
                        .opacity(self.index == 0 ? 1 : 0.25)
                    Register(index: self.$index, loading: self.$loading, AlertVisibilty: self.$AlertVisibilty, title: self.$title, message: self.$message)
                        .zIndex(self.index == 0 ? 0 : 1)
                        .opacity(self.index == 0 ? 0 : 1)
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            if self.AlertVisibilty{
                AlertBox(AlertVisibilty: self.$AlertVisibilty, loading: self.$loading, title: self.title, message: self.message)
            }
        }
        .background(Color("Background").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

// iPhone 12 Pro Max
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")
    }
}
