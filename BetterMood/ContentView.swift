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
    @State var index = 0
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
                    Login(index: self.$index)
                        .zIndex(self.index == 0 ? 1 : 0)
                        .opacity(self.index == 0 ? 1 : 0.25)
                    Register(index: self.$index)
                        .zIndex(self.index == 0 ? 0 : 1)
                        .opacity(self.index == 0 ? 0 : 1)
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(Color("Background").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

// Login Page
struct Login : View {
    @Binding var index: Int
    @State var email = ""
    @State var password = ""
    @State var show_hide = 0
    // Email Validator
    func textFieldValidatorEmail(_ string: String) -> Bool {
            if string.count > 100 {
                return false
            }
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // short format
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: string)
    }
    var body: some View{
        ZStack(alignment: .bottom){
            VStack{
                HStack {
                    Text("Login")
                        .foregroundColor(Color("Color"))
                        .font(.system(size: 40))
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                .padding(.top, 25)
                VStack{
                    HStack(spacing: 25){
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("Color"))
                        SuperTextField(placeholder: Text("Email Address").foregroundColor(Color("Disabled")), text: self.$email)
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 20))
                            .padding(.vertical, 10)
                        .padding(.leading, 7.5)
                    }
                    Divider().background(Color("Disabled"))
                    HStack(spacing: 25){
                        Image(systemName: self.show_hide == 0 ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(Color("Color"))
                            .onTapGesture {
                                if self.show_hide == 1 {
                                    self.show_hide = 0
                                } else {
                                    self.show_hide = 1
                                }
                            }
                        if self.show_hide == 0 {
                            SuperSecureField(placeholder: Text("Password").foregroundColor(Color("Disabled")), text: self.$password)
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                        } else {
                            SuperTextField(placeholder: Text("Password").foregroundColor(Color("Disabled")), text: self.$password)
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                        }
                        
                    }
                    Divider().background(Color("Disabled"))
                        .padding(.bottom, 25)
                    HStack(spacing: 25){
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                            Text("Forget your password?")
                                .foregroundColor(Color("Color").opacity(0.9))
                                .font(.system(size: 15))
                        }
                    }
                    HStack(spacing: 25){
                        Spacer(minLength: 0)
                        Button(action: {
                            self.index = 1
                        }){
                            Text("Not registered? Sign up now")
                                .foregroundColor(Color("Color").opacity(0.9))
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

// Register Page
struct Register : View {
    @Binding var index: Int
    @State var fname = ""
    @State var lname = ""
    @State var day = ""
    @State var month = ""
    @State var year = ""
    @State var email = ""
    @State var password = ""
    @State var show_hide = 0
    // Email Validator
    func textFieldValidatorEmail(_ string: String) -> Bool {
            if string.count > 100 {
                return false
            }
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // short format
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: string)
    }
    var body: some View{
        ZStack(alignment: .bottom){
            VStack{
                HStack {
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    Text("Register")
                        .foregroundColor(Color("Color"))
                        .font(.system(size: 40))
                }
                .padding(.top, 25)
                VStack{
                    VStack{
                        HStack(spacing: 25){
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("Color"))
                            SuperTextField(placeholder: Text("First name").foregroundColor(Color("Disabled")), text: self.$fname)
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                            SuperTextField(placeholder: Text("Last name").foregroundColor(Color("Disabled")), text: self.$lname)
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                        }
                        Divider().background(Color("Disabled"))
                    }
                    VStack {
                        HStack(spacing: 25){
                            Image(systemName: "calendar")
                                .foregroundColor(Color("Color"))
                            SuperTextField(placeholder: Text("DD").foregroundColor(Color("Disabled")), text: self.$day)
                                .keyboardType(.decimalPad)
                                .onReceive(day.publisher.collect()) {
                                        day = String($0.prefix(2))
                                }
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                            SuperTextField(placeholder: Text("MM").foregroundColor(Color("Disabled")), text: self.$month)
                                .keyboardType(.decimalPad)
                                .onReceive(month.publisher.collect()) {
                                        month = String($0.prefix(2))
                                }
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                            SuperTextField(placeholder: Text("YYYY").foregroundColor(Color("Disabled")), text: self.$year)
                                .keyboardType(.decimalPad)
                                .onReceive(year.publisher.collect()) {
                                        year = String($0.prefix(4))
                                }
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                        }
                        Divider().background(Color("Disabled"))
                    }
                    VStack{
                        HStack(spacing: 25){
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color("Color"))
                            SuperTextField(placeholder: Text("Email Address").foregroundColor(Color("Disabled")), text: self.$email)
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 20))
                                .padding(.vertical, 10)
                        }
                        Divider().background(Color("Disabled"))
                    }
                    VStack{
                        HStack(spacing: 25){
                            Image(systemName: self.show_hide == 0 ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color("Color"))
                                .onTapGesture {
                                    if self.show_hide == 1 {
                                        self.show_hide = 0
                                    } else {
                                        self.show_hide = 1
                                    }
                                }
                            if self.show_hide == 0 {
                                SuperSecureField(placeholder: Text("Password").foregroundColor(Color("Disabled")), text: self.$password)
                                    .foregroundColor(Color("Color"))
                                    .font(.system(size: 20))
                                    .padding(.vertical, 10)
                                    .padding(.leading, -5)
                            } else {
                                SuperTextField(placeholder: Text("Password").foregroundColor(Color("Disabled")), text: self.$password)
                                    .foregroundColor(Color("Color"))
                                    .font(.system(size: 20))
                                    .padding(.vertical, 10)
                                    .padding(.leading, -5)
                            }
                            
                        }
                        Divider().background(Color("Disabled"))
                    }
                    HStack(spacing: 25){
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        Button(action: {
                            self.index = 0
                        }){
                            Text("Already have an account? Login now")
                                .foregroundColor(Color("Color").opacity(0.9))
                                .font(.system(size: 15))
                        }
                    }
                }
                .padding(.top, 25)
                .padding(.bottom, 25)
            }
            .padding(.all, 25)
            .background(Color("Background_2"))
            .clipShape(CShape_2())
            Button(action: {}){
                Text("Sign Up")
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

// Register Shape
struct CShape_2 : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
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
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")
//        ContentView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
//           .previewDisplayName("iPhone 12")
        
    }
}
