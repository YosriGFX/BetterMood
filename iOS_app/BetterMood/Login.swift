//
//  Login.swift
//  BetterMood
//
//  Created by Yosri on 7/9/2021.
//

import Foundation
import SwiftUI
import Firebase

// Login Page
struct Login: View {
    @Binding var index: Int
    @State var email = ""
    @State var password = ""
    @State var show_hide = 0
    @Binding var loading: Bool
    @Binding var AlertVisibilty: Bool
    @Binding var title: String
    @Binding var message: String
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
                        Button(action: {
                            Reset()
                        }){
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
            Button(action: {
                self.loading = true
                SignIn()
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
                    Text("Sign In")
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
    // SignIn Function
    func SignIn(){
        let emailCheck = textFieldValidatorEmail(self.email)
        if  emailCheck && self.password.count > 6 {
            Auth.auth().signIn(withEmail: self.email, password: self.password){(res, err) in
                if err != nil {
                    if err!.localizedDescription.contains("no user record"){
                        self.title = "User not found"
                        self.message = "We couldn't find your account, please sign up."
                    } else if err!.localizedDescription.contains("password is invalid"){
                        self.title = "Invalid Password"
                        self.message = "The password your entered is invalid, please try again."
                    } else {
                        self.title = "Login Error"
                        self.message = "We are currently working on resolving the issue, please try again later."
                        print(err.debugDescription)
                    }
                    self.AlertVisibilty.toggle()
                } else {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        UserDefaults.standard.set(user.uid, forKey: "user_id")
                        if User().fetch_user_api(uid: user.uid) {
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            self.message = "Success"
                            self.loading = false
                        } else {
                            self.title = "Error"
                            self.message = "Unknown error. Please try again later."
                            self.AlertVisibilty.toggle()
                        }
                    } else {
                        self.title = "Error"
                        self.message = "Unknown error. Please try again later."
                        self.AlertVisibilty.toggle()
                    }
                }
            }
        } else if !emailCheck {
            self.title = "Invalid Email"
            self.message = "Please verify your email and try again."
            self.AlertVisibilty.toggle()
        } else {
            self.title = "Invalid Password"
            self.message = "Please enter your password."
            self.AlertVisibilty.toggle()
        }
    }
    // Password reset
    func Reset(){
        let emailCheck = textFieldValidatorEmail(self.email)
        if emailCheck {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil {
                    self.title = "User not found"
                    self.message = "We couldn't find your account, please sign up."
                    self.AlertVisibilty.toggle()
                } else {
                    self.title = "Success"
                    self.message = "An email has been sent to " + self.email + " with all instructions to reset your password."
                    self.AlertVisibilty.toggle()
                }
            }
        } else {
            self.title = "Invalid Email"
            self.message = "Please verify your email and try again."
            self.AlertVisibilty.toggle()
        }
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

// Login Shape
struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
