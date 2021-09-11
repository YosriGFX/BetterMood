//
//  CameraModel.swift
//  BetterMood
//
//  Created by Yosri on 10/9/2021.
//

import Foundation
import SwiftUI
import AVFoundation
import Firebase

// Camera Frame
struct CameraView: View{
    @State var fname = UserDefaults.standard.string(forKey: "fname") ?? ""
    @State var lname = UserDefaults.standard.string(forKey: "lname") ?? ""
    @Binding var SignoutBox_visibilty: Bool
    @ObservedObject var camera: CameraModel
    var body: some View {
        ZStack {
            VStack(){
                Text("Welcome " + fname + ", ")
                    .bold()
                    .foregroundColor(Color("Color"))
                    .font(.system(size: 30))
                    .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                Divider().background(Color("Color"))
                Text("Let's take a selfie")
                    .foregroundColor(Color("Color").opacity(0.75))
                    .font(.system(size: 25))
                    .padding(.vertical, 20)
                    .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                VStack {
                    CameraPreview(camera: camera).offset(y: -200)
                }
                .frame(width: 375, height: 500)
                .cornerRadius(50)
                .padding(.bottom, 35)
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
                if camera.isTaken {
                    if !camera.reqStarted {
                        Button(action: {
                            camera.savePic()
                        }){
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color("Background_2"))
                                .padding(.all, 10)
                                .frame(width: 60, height: 60)
                                .background(Color("Color"))
                                .clipShape(Capsule())
                                .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("Background_2")))
                            .frame(width: 60, height: 60)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                    }
                } else {
                    Button(action: camera.takePic){
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color("Background_2"))
                            .padding(.all, 5)
                            .frame(width: 60, height: 60)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .shadow(color: Color("Background_2"), radius: 5, x: 0, y: 5)
                    }
                }
                Spacer()
                if camera.isTaken && !camera.reqStarted {
                    Button(action: camera.reTake){
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
        .onAppear(perform: {
            camera.Check()
        })
    }
}

// UIImage edit
extension UIImage {
    func makeFixOrientation() -> UIImage {
        print("UIImage Here")
        if self.imageOrientation == UIImage.Orientation.left {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: self.size.height / 6, width: self.size.width, height: self.size.height))
        var normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let new_size = CGSize(width: self.size.width - 200, height: self.size.height * 3 / 5)
        UIGraphicsBeginImageContextWithOptions(new_size, false, self.scale)
        self.draw(in: CGRect(x: -100, y: -(self.size.height / 6), width: self.size.width, height: self.size.height))
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage;
    }
}

// CameraModel Class
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var message = ""
    @Published var isTaken = false
    @Published var alert = false
    @Published var isSaved = false
    @Published var reqStarted = false
    @Published var picData = Data(count: 0)
    @Published var emotions: [String: Double] = [
        "angry": 0.0,
        "disgust": 0.0,
        "fear": 0.0,
        "happy": 0.0,
        "sad": 0.0,
        "surprise": 0.0,
        "neutral": 0.0
    ]
    @Published var horoscope: [String: String] = [:]
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    func setUp() {
        do {
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let input = try AVCaptureDeviceInput(device: device!)
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken = true
                    self.reqStarted = false
                }
            }
        }
    }
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{
                    self.isSaved = false
                    self.isTaken = false
                    self.reqStarted = false
                }
            }
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        let imageData = photo.fileDataRepresentation()!
        self.picData = imageData
        print("Session stopping")
        self.session.stopRunning()
    }
    func savePic() {
        self.reqStarted = true
        self.message = "Detecting Picture.."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let image = UIImage(data: self.picData)!.makeFixOrientation()
            func getBase64Image(image: UIImage, complete: @escaping (String?) -> ()) {
                    DispatchQueue.main.async {
                        let imageData = image.jpegData(compressionQuality: 10)
                        let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
                        complete(base64Image)
                    }
            }
            getBase64Image(image: image) { base64Image in
                self.message = "Analysing Picture.."
                let url = URL(string: domain().domain + "/ios/post_image")
                let boundary = "Boundary-\(UUID().uuidString)"
                var request = URLRequest(url: url!)
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                var body = ""
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"image\""
                body += "\r\n\r\n\(base64Image ?? "")\r\n"
                body += "--\(boundary)--\r\n"
                let postData = body.data(using: .utf8)
                request.httpBody = postData
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let decodedUsers = try? JSONDecoder().decode([String: Double].self, from: data) {
                            self.emotions = decodedUsers
                            self.message = "Finishing Request.."
                            let user = Auth.auth().currentUser
                            if let user = user {
                                let url = URL(string: domain().domain + "/ios/astrology")
                                guard let requestUrl = url else {
                                    return
                                }
                                var request = URLRequest(url: requestUrl)
                                request.httpMethod = "POST"
                                let postString = "user_id=" + user.uid;
                                request.httpBody = postString.data(using: String.Encoding.utf8);
                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data {
                                        if let decodedHoroscope = try? JSONDecoder().decode([String: String].self, from: data) {
                                            self.horoscope = decodedHoroscope
                                            self.isSaved = true
                                        } else {
                                            self.alert = true
                                            self.isSaved = false
                                            print("Failed Api Decoder")
                                        }
                                    } else {
                                        self.alert = true
                                        self.isSaved = false
                                        print("Failed Api Astrology")
                                    }
                                }.resume()
                                
                            } else {
                                self.alert = true
                                self.isSaved = false
                                UserDefaults.standard.set(false, forKey: "status")
                                print("Failed Firebase")
                            }
                        } else {
                            self.alert = true
                            self.isSaved = false
                            print("Failed Decoder")
                        }
                    } else {
                        self.alert = true
                        self.isSaved = false
                    }
                }.resume()
            }
        }
        
    }
}

// CameraPreview Struct
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        camera.session.startRunning()
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {

    }
}
