//
//  ResultPage.swift
//  BetterMood
//
//  Created by Yosri on 10/9/2021.
//

import Foundation
import SwiftUI
import SwiftUICharts

// Result Page
struct ResultPageLoading: View{
    @State var fname = UserDefaults.standard.string(forKey: "fname") ?? ""
    @State var lname = UserDefaults.standard.string(forKey: "lname") ?? ""
    @Binding var SignoutBox_visibilty: Bool
    @ObservedObject var camera: CameraModel
    var body: some View {
        ZStack(alignment: .top) {
            VStack(){
                Text(fname + ", Take a look !")
                    .bold()
                    .foregroundColor(Color("Color"))
                    .font(.system(size: 30))
                    .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                    .padding(.top, 10)
                Divider().background(Color("Color"))
                if camera.isSaved {
                    ScrollView(.vertical) {
                        ChartBox(emotions: camera.emotions)
                        ForEach(camera.horoscope.sorted(by:<), id: \.key) { key, value in
                            BoxMessage(title: String(key.dropFirst(2)), message: value)
                        }
                    }
                } else {
                    VStack(alignment: .center) {
                        Loading()
                        Text(camera.message)
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 20))
                            .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                            .padding(.top, 50)
                    }
                    .padding(.top, 175)
                }
            }
            .offset(y: -50)
            HStack {
                Button(action: {
                    self.SignoutBox_visibilty.toggle()
                }){
                    Image(systemName: "eject.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("Color"))
                        .padding(.all, 10)
                        .frame(width: 55, height: 55)
                        .background(Color("Red"))
                        .clipShape(Capsule())
                        .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                }
                Spacer()
                if (camera.isTaken && !camera.reqStarted) || camera.isSaved{
                    Button(action: {
                        withAnimation(.linear) {
                            camera.isSaved = false
                            camera.isTaken = false
                            camera.reqStarted = false
                        }
                    }){
                        Image(systemName: "repeat")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("Red"))
                            .padding(.all, 5)
                            .frame(width: 55, height: 55)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                    }
                } else {
                    Button(action: {}){
                        Image(systemName: "repeat")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("Background_2"))
                            .padding(.all, 5)
                            .frame(width: 55, height: 55)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .opacity(0.5)
                            .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                    }
                }
                
            }
            .padding(.horizontal, 35)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

// Loading
struct Loading: View {
    @State var degress = 0.0
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.6)
            .stroke(Color("Color"), lineWidth: 5.0)
            .frame(width: 120, height: 120)
            .rotationEffect(Angle(degrees: degress))
            .onAppear(perform: {self.start()})
    }
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            withAnimation {
                self.degress += 10.0
            }
            if self.degress == 360.0 {
                self.degress = 0.0
            }
        }
    }
}

// ChartBox Struct
struct ChartBox: View {
    var emotions: [String: Double] = [
        "angry": 0.0,
        "disgust": 0.0,
        "fear": 0.0,
        "happy": 0.0,
        "sad": 0.0,
        "surprise": 0.0,
        "neutral": 0.0
    ]
    var body: some View {
        VStack {
            Text("Facial Analyse")
                .foregroundColor(Color("Legend"))
                .font(.system(size: 18))
                .bold()
            Divider().background(Color("Color"))
            HStack {
                Spacer(minLength: 20)
                HorizontalBarChartView(dataPoints: [
                    .init(value: self.emotions["neutral"]!, label: "Neutral", legend: Legend(color: Color("neutral"), label: LocalizedStringKey(String(self.emotions["neutral"]!) + "%"))),
                    .init(value: self.emotions["happy"]!, label: "Happy", legend: Legend(color: Color("happy"), label: LocalizedStringKey(String(self.emotions["happy"]!) + "%"))),
                    .init(value: self.emotions["angry"]!, label: "Angry", legend: Legend(color: Color("angry"), label: LocalizedStringKey(String(self.emotions["angry"]!) + "%"))),
                    .init(value: self.emotions["sad"]!, label: "Sad", legend: Legend(color: Color("sad"), label: LocalizedStringKey(String(self.emotions["sad"]!) + "%"))),
                    .init(value: self.emotions["surprise"]!, label: "Surprise", legend: Legend(color: Color("surprise"), label: LocalizedStringKey(String(self.emotions["surprise"]!) + "%"))),
                    .init(value: self.emotions["fear"]!, label: "Fear", legend: Legend(color: Color("fear"), label: LocalizedStringKey(String(self.emotions["fear"]!) + "%"))),
                    .init(value: self.emotions["disgust"]!, label: "Disgust", legend: Legend(color: Color("disgust"), label: LocalizedStringKey(String(self.emotions["disgust"]!) + "%")))
                ])
            }
        }
        .font(.system(size: 16))
        .foregroundColor(Color("Legend"))
        .padding(.all, 25)
        .background(Color("Background_2"))
        .cornerRadius(50)
        .shadow(color: Color("Background_2"), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 7.5)
        .padding(.vertical, 5)
        .background(Color("Color"))
        .cornerRadius(50)
        .shadow(color: Color("Background_2"), radius: 15, x: 0, y: 0)
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
}
// BoxMessage Struct
struct BoxMessage: View {
    var title: String
    var message: String
    var body: some View {
        VStack {
            Text(self.title)
                .foregroundColor(Color("Legend"))
                .font(.system(size: 18))
                .bold()
            Divider().background(Color("Color"))
            Text(self.message)
                .foregroundColor(Color("Legend"))
                .font(.system(size: 18))
        }
        .foregroundColor(Color("Legend"))
        .padding(.all, 25)
        .background(Color("Background_2"))
        .cornerRadius(50)
        .shadow(color: Color("Background_2"), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 7.5)
        .padding(.vertical, 5)
        .background(Color("Color"))
        .cornerRadius(50)
        .shadow(color: Color("Background_2"), radius: 15, x: 0, y: 0)
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
}
