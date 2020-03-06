//
//  MQIBaseModel.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/26.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


import Alamofire

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

//MARK: Object
public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

extension DataRequest {
    @discardableResult func responseObject<T: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(BackendError.objectSerialization(reason: "数据为空"))
            }
            if response.statusCode == 200 {
                return .success(responseObject)
            }
            
            if let error = GYResultModel(response: response, representation: jsonObject)?.gError {
                return .failure(NSError.init(domain: error.detail, code: error.code, userInfo: ["code:" : error.code, "msg" : error.detail]) as Error)
            }else {
                return .success(responseObject)
            }
            
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

public protocol ResponseCollectionSerializable {
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self] {
        var collection: [Self] = []
        
        if let representation = representation as? [[String: Any]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    collection.append(item)
                }
            }
        }else if let representation = representation as? [String : Any] {
            if let book = Self(response: response, representation: representation as Any) {
                collection.append(book)
            }
        }else if let representation = representation as? [Self] {
            collection.append(contentsOf: representation)
        }
        
        return collection
    }
}

extension DataRequest {
    @discardableResult
    func responseCollection<T: ResponseCollectionSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            mqLog("~~list~~ = \(jsonObject)")
            guard let response = response else {
                let reason = "Response collection could not be serialized due to nil response."
                return .failure(BackendError.objectSerialization(reason: reason))
            }
            
            if let error = GYResultModel(response: response, representation: jsonObject)?.gError {
                return .failure(NSError.init(domain: error.detail, code: error.code, userInfo: ["code:" : error.code, "msg" : error.detail]) as Error)
            }else {
                return .success(T.collection(from: response, withRepresentation: jsonObject))
            }
            
            
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
//import HandyJSON
@objcMembers
//MARK: MQIBaseModel
class MQIBaseModel: NSObject, ResponseObjectSerializable, NSCoding {
    
    var dict = [String: Any]()
    var obj: Any?
    
    override init() {
        super.init()
        
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init()
        if representation is [String : Any] {
            dict = representation as! [String : Any]
            self.setValuesForKeys(representation as! [String : Any])
        }else {
            obj = representation
        }
    }
    
    required init(jsonDict: [String : Any]) {
        super.init()
        dict = jsonDict
        self.setValuesForKeys(jsonDict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if let value = value {
            
            if value is NSNumber {
                super.setValue("\(value)", forKey: key)
            }else if value is String {
                super.setValue(value, forKey: key)
            }else {
                super.setValue(value, forKey: key)
            }
        }
    }
    
    func setDictToModel<T: MQIBaseModel>(_ value: Any?, key: String) -> T {
        if let value = value {
            if value is [String : Any] {
                let model = T(jsonDict: (value as! [String : Any]))
                return model
            }
        }
        return T(jsonDict: [String : Any]())
    }
    
    func setValueToArray<T: MQIBaseModel>(_ value: Any?, key: String) -> [T] {
        var array = [T]()
        if let value = value {
            if value is [Any] {
                for dict in value as! [Any] {
                    if dict is [String : Any] {
                        let r = T(jsonDict: dict as! [String : Any])
                        array.append(r)
                    }
                }
            }
        }
        return array
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //        gLog("Undefined Key:\(key) in \(self.classForCoder)")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        for key in allPropertyNames() {
            if let value = aDecoder.decodeObject(forKey: key) {
                //                MQLog("\(key)   ------    \(value)")
                setValue(value, forKey: key)
            }
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        for (key, value) in allPropertys() {
            if let value = value {
                //                MQLog("\(key)   =======    \(value)")
                aCoder.encode(value, forKey: key)
            }
        }
    }
    
    
}

//MARK: ResponseModel
class GYResponseModel<T: MQIBaseModel>: MQIBaseModel {
    
    var count: String = ""
    var next: String = ""
    var previous: String = ""
    
    var resultsArray = [T]()
    
    override init() {
        super.init()
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init()
        self.setValuesForKeys(representation as! [String : Any])
    }
    
    required init(jsonDict: [String : Any]) {
        super.init()
        self.setValuesForKeys(jsonDict)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "results" {
            resultsArray = setValueToArray(value, key: key)
            
        }else {
            super.setValue("", forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("Undefined Key:\(key) in \(self.classForCoder)")
    }
    
}


//MARK: ResultModel
class GYResultModel: MQIBaseModel {
    
    var gError: GYError?
    var code:String = ""
    var desc:String = ""
    var message: String = ""
    
    func createGError() {
        if gError == nil {
            gError = GYError()
        }
    }
    
    override init() {
        super.init()
    }
    
    required init(jsonDict: [String : Any]) {
        super.init()
        self.setValuesForKeys(jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init()
        if representation is [String : Any] {
            self.setValuesForKeys(representation as! [String : Any])
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "code" {
            createGError()
            if value is String || value is Int || value is Float {
                gError!.code = NSString(string: "\(value!)").integerValue
            }else {
                gError!.code = -1
            }
        }else if key == "desc" {
            createGError()
            if value is String || value is Int || value is Float {
                gError!.detail = "\(value!)"
            }else {
                gError!.detail = "网络错误"
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

class GYError: MQIBaseModel {
    var code: Int = 0
    var detail: String = ""
    var body: String = ""
    var host: String = ""
    
}

extension String: ResponseCollectionSerializable {
    public static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [String] {
        var collection: [String] = []
        
        if let representation = representation as? [String] {
            collection.append(contentsOf: representation)
        }
        
        return collection
    }
    
    
}
