//
//  ContentView.swift
//  BetterMood
//
//  Created by Yosri on 5/9/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct SuperTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct SuperSecureField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text, onCommit: commit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                Image("logo_text")
                    .resizable()
                    .frame(width: 797 / 4, height: 488 / 4)
                    .padding(.bottom, 25)
                Login()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(Color("Background").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

struct Login : View {
    @State var email = ""
    @State var password = ""
    
    var body: some View{
        VStack{
            HStack {
                Text("Login")
                    .foregroundColor(Color("Color"))
                    .font(.system(size: 50))
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            VStack{
                HStack(spacing: 25){
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("Color"))
                    SuperTextField(placeholder: Text("Email Address").foregroundColor(Color("Disabled")), text: self.$email)
                        .foregroundColor(Color("Color"))
                        .font(.system(size: 25))
                        .padding(.vertical, 10)
                }
                Divider().background(Color("Disabled"))
                HStack(spacing: 25){
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color("Color"))
                    SuperSecureField(placeholder: Text("Password").foregroundColor(Color("Disabled")), text: self.$password)
                        .foregroundColor(Color("Color"))
                        .font(.system(size: 25))
                        .padding(.vertical, 10)
                }
                Divider().background(Color("Disabled"))
            }
            .padding(.top, 25)
            .padding(.bottom, 50)
        }
        .padding(.all, 25)
        .background(Color("Background_2"))
    }
}
