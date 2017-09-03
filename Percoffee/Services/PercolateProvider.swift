//
//  PercolateProvider.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 03/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import Foundation
import Moya
import Result

final class PercolateProvider {
    
    private let provider = MoyaProvider<PercolateService>(callbackQueue: DispatchQueue.global(), plugins: [EmptyStringPlugin()])
    private let decoder = PercolateJSONDecoder()
    
    func requestCoffeeInfos(completion: @escaping (Result<[CoffeeInfo], NSError>) -> Void) -> Cancellable {
        return provider.request(.getCoffeeInfos, completion: { (result) in
            do {
                let response = try result.dematerialize()
                let coffeeInfos = try self.decoder.decode([CoffeeInfo].self, from: response.data)
                DispatchQueue.main.async {
                    completion(.success(coffeeInfos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error as NSError))
                }
            }
        })
    }
    
    func requestCoffeeDetailInfo(withCoffeeInfo coffeeInfo: CoffeeInfo, completion: @escaping (Result<CoffeeDetailInfo, NSError>) -> Void) -> Cancellable {
        return provider.request(.getCoffeeInfo(identifier: coffeeInfo.identifier), completion: { (result) in
            do {
                let response = try result.dematerialize()
                let coffeeDetailInfo = try self.decoder.decode(CoffeeDetailInfo.self, from: response.data)
                DispatchQueue.main.async {
                    completion(.success(coffeeDetailInfo))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error as NSError))
                }
            }
        })
    }
    
}

private final class PercolateJSONDecoder: JSONDecoder {
    
    override init() {
        super.init()
        
        let dateFormatter = DateFormatter()
        //2017-08-25 16:05:57.589690
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withSpaceBetweenDateAndTime]
        dateDecodingStrategy = .formatted(dateFormatter)
    }
    
}

private final class EmptyStringPlugin: PluginType {
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        if case .success(let response) = result, let string = String(data: response.data, encoding: .utf8) {
            let fixedString = string.replacingOccurrences(of: ": \"\"", with: ": null")
            return .success(Response(statusCode: response.statusCode, data: fixedString.data(using: .utf8)!, request: response.request, response: response.response))
        }
        
        return result
    }
    
}
