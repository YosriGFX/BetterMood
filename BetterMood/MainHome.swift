//
//  MainHome.swift
//  BetterMood
//
//  Created by Yosri on 9/9/2021.
//

import Foundation
import SwiftUI
import Firebase

// MainHome
struct MainHome: View{
    @State var SignoutBox_visibilty = false
    @State var isCamera = true
    @State var message = ""
    @StateObject var camera = CameraModel()
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack {
                    Image("logo_text")
                        .resizable()
                        .frame(width: 797 / 8, height: 488 / 8)
                        .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                        .padding(.all, 20)
                }
                .padding(.top, 40)
                .frame(width: geometry.size.width)
                .background(Color("Background_2").opacity(0.7))
                .offset(y: -100)
                .offset(y: 50)
                if !camera.reqStarted && !camera.isSaved {
                    CameraView(SignoutBox_visibilty: self.$SignoutBox_visibilty, camera: camera)

                } else {
                    ResultPageLoading(SignoutBox_visibilty: self.$SignoutBox_visibilty, camera: camera)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color("Background").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            if self.SignoutBox_visibilty {
                SignoutBox(SignoutBox_visibilty: self.$SignoutBox_visibilty)
            }
            if camera.alert {
                AlertPop(camera: camera)
            }
        }
    }
}

// Signout Box
struct AlertPop: View{
    @ObservedObject var camera: CameraModel
    var body: some View{
        VStack{
            VStack{
                VStack {
                    HStack(spacing: 10){
                        Text("Error.")
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 25))
                            .padding(.bottom, 5)
                    }
                    Divider().background(Color("Disabled"))
                    Text("We are unable to handle your picture.")
                        .foregroundColor(Color("Color"))
                        .font(.system(size: 18))
                        .bold()
                        .padding(.top, 5)
                        .padding(.bottom, 2.5)
                    Text(" -\tVerify your network connection.\n -\tCheck your camera permissions.\n -\tEnsure that your face is clear.")
                        .foregroundColor(Color("Color").opacity(0.75))
                        .font(.system(size: 18))
                        .padding(.bottom, 15)
                        .padding(.horizontal, 15)
                }
                .padding(.top, 15)
                .padding(.bottom, 25)
                .background(Color("Background"))
                .cornerRadius(25)
                .padding(.horizontal, 25)
                HStack {
                    Button(action: {
                        withAnimation(.linear) {
                            camera.isSaved = false
                            camera.isTaken = false
                            camera.reqStarted = false
                            camera.alert = false
                        }
                    }){
                        Text("Retry")
                            .bold()
                            .foregroundColor(Color("Background"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .shadow(color: Color("Background_2"), radius: 10, x: 0, y: 0)
                            .padding(.leading, 5)
                    }
                }
                .padding(.top, -35)
            }
            .padding(.top, -50)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("Background_2").opacity(0.8).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

// Signout Box
struct SignoutBox: View{
    @Binding var SignoutBox_visibilty: Bool
    var body: some View{
        VStack{
            VStack{
                VStack {
                    HStack(spacing: 10){
                        Text("Logout")
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 25))
                            .padding(.bottom, 10)
                    }
                    Divider().background(Color("Disabled"))
                    Text("Are you sure about signing out ?")
                        .foregroundColor(Color("Color").opacity(0.75))
                        .font(.system(size: 20))
                        .padding(.bottom, 15)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 15)
                .padding(.bottom, 25)
                .background(Color("Background"))
                .cornerRadius(25)
                .padding(.horizontal, 25)
                HStack {
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }){
                        Text("Yes")
                            .bold()
                            .foregroundColor(Color("Color"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("Red"))
                            .clipShape(Capsule())
                            .shadow(color: Color("Background_2"), radius: 10, x: 0, y: 0)
                            .padding(.trailing, 5)
                    }
                    Button(action: {
                        self.SignoutBox_visibilty.toggle()
                    }){
                        Text("No")
                            .bold()
                            .foregroundColor(Color("Background"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .shadow(color: Color("Background_2"), radius: 10, x: 0, y: 0)
                            .padding(.leading, 5)
                    }
                }
                .padding(.top, -35)
            }
            .padding(.top, -50)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("Background_2").opacity(0.8).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
