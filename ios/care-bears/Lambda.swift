//
//  Lambda.swift
//  care-bears
//
//  Created by Samuel Echikson on 1/10/19.
//  Copyright © 2019 Samuel Echikson. All rights reserved.
//

import AWSLambda

class Lambda: NSObject {
    var lambda: AWSLambda!
    
    override init() {        
        self.lambda = AWSLambda.default()
        print("initialized Lambda")
    }
    
    func checkIn() {
        let request = AWSLambdaInvocationRequest()
        request?.functionName = "WriteToTable"
        let jsonDict: [String:Any] = [
            "tableName": "room_check_in",
            "id": 1
        ]
        request?.payload = try! JSONSerialization.data(withJSONObject: jsonDict)
        self.lambda.invoke(request!).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                print("Updated Database \(String(describing: task.result.debugDescription))")
            }
            return nil;
        }
    }
}
