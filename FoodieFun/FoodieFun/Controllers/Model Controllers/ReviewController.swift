//
//  ReviewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/7/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

class ReviewController {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum HttpHeaderType: String {
        case contentType = "Content-Type"
    }
    
    enum HttpHeaderValue: String {
        case json = "application/json"
    }
    
    struct EncodingStatus {
        let request: URLRequest?
        let error: Error?
    }
    
    var bearer: Bearer?
    var baseURL = URL(string: "https://foodiefunbw.herokuapp.com/")!

    static var df: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }
    /**
     Create a request given a URL and requestMethod (get, post, create, etc...)
     */
    class func createRequest(url: URL?, method: HttpMethod, headerType: HttpHeaderType? = nil, headerValue: HttpHeaderValue? = nil) -> URLRequest? {
        guard let requestUrl = url else {
            NSLog("request URL is nil")
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        if let headerType = headerType,
            let headerValue = headerValue {
            request.setValue(headerValue.rawValue, forHTTPHeaderField: headerType.rawValue)
        }
        return request
    }
    
    class func encode(from type: Any?, request: URLRequest) -> EncodingStatus {
        var localRequest = request
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(df)
        do {
            switch type {
            case is EntryRepresentation:
                localRequest.httpBody = try jsonEncoder.encode(type as? EntryRepresentation)
            default: fatalError("\(String(describing: type)) is not defined locally in encode function")
            }
        } catch {
            print("Error encoding object into JSON \(error)")
            return EncodingStatus(request: nil, error: error)
        }
        return EncodingStatus(request: localRequest, error: nil)
    }
    
    class func decode(to type: Any?, data: Data) -> [String:EntryRepresentation]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(df)
        do {
            switch type {
            case is [String:EntryRepresentation].Type:
                let entries = try decoder.decode([String:EntryRepresentation].self, from: data)
                return entries
            default: fatalError("type \(String(describing: type)) is not defined locally in decode function")
            }
        } catch {
            print("Error Decoding JSON into \(String(describing: type)) Object \(error)")
            return nil
        }
    }
}
