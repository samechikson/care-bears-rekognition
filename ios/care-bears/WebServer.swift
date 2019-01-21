//
//  WebServer.swift
//  care-bears
//
//  Created by Samuel Echikson on 1/17/19.
//  Copyright © 2019 Samuel Echikson. All rights reserved.
//

import Foundation
import Swifter

class WebServer {
    
    var server: HttpServer!
    
    var delegate: WebServerDelegate?
    
    init() {
        self.server = HttpServer()
        self.server["/taskDone"] = { request in
            print("Captured HTTP call to /taskDone with request", request.queryParams)
            DispatchQueue.main.async {
                self.delegate?.taskDone(self)
            }
            return HttpResponse.ok(.text("Ok"))
        }
        do {
            try self.server.start()
            try? print("Initialized and started web server on port \(self.server.port())")
        } catch let error {
            print("Could not create web server", error)
        }
    }
}
