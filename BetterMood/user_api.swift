//
//  user_api.swift
//  BetterMood
//
//  Created by Yosri on 9/9/2021.
//

import Foundation

// Domain Name
class domain: ObservableObject {
    let domain = "ENDPOINT_URL"
}


// users
struct users: Codable {
    var fname: String
    var lname: String
}

// User API
struct User {
    func register_api(uid: String, fname: String, lname: String, day: String, month: String, year: String, email: String) -> Bool {
        let sem = DispatchSemaphore.init(value: 0)
        var success = false
        let url = URL(string: domain().domain + "/ios/register")
        guard let requestUrl = url else {
            return false
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let postString = "user_id=" + uid + "&fname=" + fname + "&lname=" + lname + "&day=" + day + "&month=" + month + "&year=" + year + "&email=" + email;
        request.httpBody = postString.data(using: String.Encoding.utf8);
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { sem.signal() }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                success = true
            } else {
                success = false
            }
        }.resume()
        sem.wait()
        return success
    }
    func fetch_user_api(uid: String) -> Bool {
        let sem = DispatchSemaphore.init(value: 0)
        var success = false
        let url = URL(string: domain().domain + "/ios/login")
        guard let requestUrl = url else {
            return false
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let postString = "user_id=" + uid;
        request.httpBody = postString.data(using: String.Encoding.utf8);
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            if let data = data {
                if let decodedUsers = try? JSONDecoder().decode(users.self, from: data) {
                    UserDefaults.standard.set(decodedUsers.fname, forKey: "fname")
                    UserDefaults.standard.set(decodedUsers.lname, forKey: "lname")
                    UserDefaults.standard.set(true, forKey: "signed_in")
                    success = true
                } else {
                    success = false
                }
            } else {
                success = false
            }
        }.resume()
        sem.wait()
        return success
    }
}
