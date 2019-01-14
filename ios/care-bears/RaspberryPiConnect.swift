//
//  raspberryPiConnect.swift
//  care-bears
//
//  Created by Samuel Echikson on 1/12/19.
//  Copyright © 2019 Samuel Echikson. All rights reserved.
//
import Foundation

class RaspberryPiConnect {
    var rpiConnectionString: String!
    
    init(connectionString: String) {
        self.rpiConnectionString = connectionString
    }
    
    func notifyLogIn() {
        guard let url = URL(string: self.rpiConnectionString) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let jsonBody: Data
        jsonBody = "ipad=init".data(using: .utf8)!
        urlRequest.httpBody = jsonBody
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on \(self.rpiConnectionString ?? "")")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                print(String(decoding: responseData, as: UTF8.self))
                guard let response = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }

                print(response)
            } catch  {
                print("error parsing response from POST on \(self.rpiConnectionString)")
                return
            }
        }
        task.resume()
    }
//
//    func notifyLogIn() {
//        // Set up the URL request
//        guard let url = URL(string: self.rpiConnectionString) else {
//            print("Error: cannot create URL")
//            return
//        }
//        let urlRequest = URLRequest(url: url)
//
//        // set up the session
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//        // make the request
//        let task = session.dataTask(with: urlRequest) {
//            (data, response, error) in
//            // check for any errors
//            guard error == nil else {
//                print("error calling GET on Raspberry Pi")
//                print(error!)
//                return
//            }
//            // make sure we got data
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//            // parse the result as JSON, since that's what the API provides
//            do {
//
//                guard let resp = try JSONSerialization.jsonObject(with: responseData, options: [])
//                    as? [String: Any] else {
//                        print("error trying to convert data to JSON")
//                        return
//                }
//                print(resp)
////                // now we have the todo
////                // let's just print it to prove we can access it
////                print("The todo is: " + todo.description)
//
//                // the todo object is a dictionary
//                // so we just access the title using the "title" key
//                // so check for a title and print it if we have one
////                guard let todoTitle = todo["title"] as? String else {
////                    print("Could not get todo title from JSON")
////                    return
////                }
////                print("The title is: " + todoTitle)
//            } catch  {
//                print("error trying to convert data to JSON")
//                return
//            }
//        }
//        task.resume()
//    }
}
