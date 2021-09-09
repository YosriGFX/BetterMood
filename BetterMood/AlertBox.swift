//
//  AlertBox.swift
//  BetterMood
//
//  Created by Yosri on 7/9/2021.
//

import Foundation
import SwiftUI

// AlertBox
struct AlertBox: View{
    @Binding var AlertVisibilty: Bool
    @Binding var loading: Bool
    @State var title: String
    @State var message: String
    var body: some View{
        VStack{
            VStack{
                VStack {
                    HStack(spacing: 10){
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 20))
                            .padding(.bottom, 10)
                        Text(self.title)
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 25))
                            .padding(.bottom, 10)
                    }
                    Divider().background(Color("Disabled"))
                    Text(self.message)
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
                Button(action: {
                    self.loading = false
                    self.AlertVisibilty.toggle()
                }){
                    Text("Cancel")
                        .bold()
                        .foregroundColor(Color("Background"))
                        .padding(.vertical)
                        .padding(.horizontal, 25)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(color: Color("Background_2"), radius: 10, x: 0, y: 0)
                }
                .padding(.top, -35)
            }
            .padding(.top, -50)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("Background_2").opacity(0.8).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
