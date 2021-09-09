//
//  Register.swift
//  BetterMood
//
//  Created by Yosri on 7/9/2021.
//

import Foundation
import SwiftUI
import Firebase

// Register Page
struct Register: View {
    @Binding var index: Int
    @Binding var loading: Bool
    @Binding var AlertVisibilty: Bool
    @Binding var title: String
    @Binding var message: String
    @State var fname = ""
    @State var lname = ""
    @State var day = ""
    @State var month = ""
    @State var year = ""
    @State var email = ""
    @State var password = ""
    @State var show_hide = 0
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
            Button(action: {
                self.loading = true
                SignUp()
            }){
                if self.loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("Background_2")))
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                } else {
                    Text("Sign Up")
                        .bold()
                        .foregroundColor(Color("Background_2"))
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                }
                
            }
            .offset(y: 25)
        }
    }
    // Register function
    func SignUp() {
        let emailCheck = textFieldValidatorEmail(self.email)
        let dayInt = Int(self.day) ?? 0
        let monthInt = Int(self.month) ?? 0
        let yearInt = Int(self.year) ?? 0
        if self.fname.count < 2 {
            self.title = "Invalid Name"
            self.message = "Please verify your First Name and try again."
            self.AlertVisibilty.toggle()
        } else if self.lname.count < 2{
            self.title = "Invalid Name"
            self.message = "Please verify your Last Name and try again."
            self.AlertVisibilty.toggle()
        } else if dayInt > 31 || dayInt < 1 {
            self.title = "Invalid Date of birth"
            self.message = "Please verify your Day of birth and try again."
            self.AlertVisibilty.toggle()
        } else if monthInt > 12 || monthInt < 1 {
            self.title = "Invalid Date of birth"
            self.message = "Please verify your Month of birth and try again."
            self.AlertVisibilty.toggle()
        } else if yearInt > 2021 || yearInt < 1921 {
            self.title = "Invalid Date of birth"
            self.message = "Please verify your Year of birth and try again."
            self.AlertVisibilty.toggle()
        } else if !emailCheck {
            self.title = "Invalid Email"
            self.message = "Please verify your email and try again."
            self.AlertVisibilty.toggle()
        } else if self.password.count < 6 {
            self.title = "Invalid Password"
            self.message = "Please enter your password."
            self.AlertVisibilty.toggle()
        } else {
            Auth.auth().createUser(withEmail: self.email, password: self.password) { (res, err) in
                if err != nil && !Api_registration(){
                    self.title = "Error"
                    self.message = "The email address is already registred, please sign in."
                    self.AlertVisibilty.toggle()
                } else if !Api_registration() {
                    self.title = "Error"
                    self.message = "Unknown error. Please try again later."
                    self.AlertVisibilty.toggle()
                }
            }
        }
    }
    // api_registration
    func Api_registration() -> Bool {
        let user = Auth.auth().currentUser
        if let user = user {
            UserDefaults.standard.set(user.uid, forKey: "user_id")
            if User().register_api(uid: user.uid, fname: self.fname, lname: self.lname, day: self.day, month: self.month, year: self.year, email: self.email) && user.email == self.email.lowercased() {
                UserDefaults.standard.set(self.fname, forKey: "fname")
                NotificationCenter.default.post(name: NSNotification.Name("fname"), object: nil)
                UserDefaults.standard.set(self.lname, forKey: "lname")
                NotificationCenter.default.post(name: NSNotification.Name("lname"), object: nil)
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                self.message = "Success"
                self.loading = false
                return true
            } else {
                return false
            }
        }
        return false
    }
    // Email Validator
    func textFieldValidatorEmail(_ string: String) -> Bool {
            if string.count > 100 {
                return false
            }
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: string)
    }
}

// Register Shape
struct CShape_2: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
