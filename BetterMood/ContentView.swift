//
//  ContentView.swift
//  BetterMood
//
//  Created by Yosri on 5/9/2021.
//

import SwiftUI

// Main View
struct ContentView: View {
    var body: some View {
        Home()
    }
}

// Home Page
struct Home : View {
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                Image("logo_text")
                    .resizable()
                    .frame(width: 797 / 4, height: 488 / 4)
                    .padding(.bottom, 40)
                    .padding(.top, 125)
                    .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                Login()
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(Color("Background").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

// Login Page
struct Login : View {
    @State var email = ""
    @State var password = ""
    var body: some View{
        ZStack(alignment: .bottom){
            VStack{
                HStack {
                    Text("Login")
                        .foregroundColor(Color("Color"))
                        .font(.system(size: 40))
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                VStack{
                    HStack(spacing: 25){
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("Color"))
                        SuperTextField(placeholder: Text("Email Address").foregroundColor(Color("Disabled")), text: self.$email)
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 20))
                            .padding(.vertical, 10)
                    }
                    Divider().background(Color("Disabled"))
                    HStack(spacing: 25){
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color("Color"))
                        SuperSecureField(placeholder: Text("Password").foregroundColor(Color("Disabled")), text: self.$password)
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 20))
                            .padding(.vertical, 10)
                    }
                    Divider().background(Color("Disabled"))
                        .padding(.bottom, 25)
                    HStack(spacing: 25){
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                            Text("Forget your password?")
                                .foregroundColor(Color("Color").opacity(0.75))
                                .font(.system(size: 15))
                        }
                    }
                }
                .padding(.top, 25)
                .padding(.bottom, 25)
            }
            .padding(.all, 25)
            .background(Color("Background_2"))
            .clipShape(CShape())
            Button(action: {}){
                Text("Sign In")
                    .bold()
                    .foregroundColor(Color("Background_2"))
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color"))
                    .clipShape(Capsule())
                    .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
        }
    }
}

// Login Shape
struct CShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

// SuperText Field
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

// SuperSecure Field
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

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
