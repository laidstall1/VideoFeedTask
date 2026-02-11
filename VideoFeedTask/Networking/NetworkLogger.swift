//
//  NetworkLogger.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 10/02/2026.
//
import Alamofire
import Foundation

final class NetworkLogger: EventMonitor {
    
    func requestDidResume(_ request: Request) {
        
        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
        let headers = """
        ⚡️⚡️⚡️⚡️ Request Started: \(request)
        ⚡️⚡️⚡️⚡️ Headers: \(allHeaders)
        """
//        NSLog(headers)
        print(headers)
        
        
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️⚡️⚡️⚡️ Request Started: \(request)
        ⚡️⚡️⚡️⚡️ Body Data: \(body)
        """
//        NSLog(message)
      print(message)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        
        NSLog("⚡️⚡️⚡️⚡️ Response Received: \(response.debugDescription)")
        NSLog("⚡️⚡️⚡️⚡️ Response All Headers: \(String(describing: response.response?.allHeaderFields))")
        
        if let data = response.data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                    if let prettyPrintedStr = String(data: jsonData, encoding: .utf8) {
                        print("⚡️⚡️⚡️⚡️ Pretty Printed Response")
                        print(prettyPrintedStr)
                    } else {
                        if let rawResponseStr = String(data: data, encoding: .utf8) {
                            NSLog("⚡️⚡️⚡️⚡️ Raw Response")
                            print(rawResponseStr)
                        }
                    }
                }
            }
        } else {
            NSLog("⚡️⚡️⚡️⚡️ Response: No Response Data")
        }
    }
}
