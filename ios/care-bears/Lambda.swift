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
            "tableName": "ipad",
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
    
    func fetchTasks(completionHandler: @escaping (_ tasks: [Task]) -> ()) {
        let request = AWSLambdaInvocationRequest()
        request?.functionName = "FetchTasks"
        let jsonReq: [String: Any] = [ "roomId": 1 ]
        request?.payload = try! JSONSerialization.data(withJSONObject: jsonReq)
        
        self.lambda.invoke(request!).continueWith { (response) -> Any? in
            if let error = response.error {
                print("Error: \(error.localizedDescription)")
            }
            
            var tasks: [Task] = []
            if let response = response.result {
//                dump(response.payload)
//                print((response.payload as! [Any]).first)
                if let tasksArray = response.payload as? [[String: Any]] {
                    
                    for task in tasksArray {
//                        print(task)
                        if let t = Task(json: task) {
                            tasks.append(t)
                        } else {
                            print("Couldn't parse task into Task()")
                        }
                    }
                }                
                completionHandler(tasks)
            }
            return nil
        }
    }
}
