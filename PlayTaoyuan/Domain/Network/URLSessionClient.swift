//
//  URLSessionClient.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import Foundation
import Combine
import SJUtil

public class URLSessionClient : NSObject {
    
    static let shared:URLSessionClient = URLSessionClient()
    
    private var _baseURL:String!
    private var _headers:[String:String] = [:]
    private var _timeoutInterval:TimeInterval = 60
    
    @discardableResult
    func setBaseUrl(_ base:String) -> Self {
        _baseURL = base
        return self
    }
    
    @discardableResult
    func setHeaders(_ headers:[String:String]) -> Self {
        _headers = headers
        return self
    }
    
    @discardableResult
    func setTimeoutInterval(_ time:TimeInterval) -> Self {
        _timeoutInterval = time
        return self
    }
    
    func send<R:JSONCodable>(_ request:Request) -> AnyPublisher<R, Error>{
        
        guard let url = URL(string: _baseURL+request.url) else { return Empty().eraseToAnyPublisher() }
        
        var _request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: _timeoutInterval)
        _request.httpMethod = request.method.rawValue
        
        _headers.forEach({ _request.addValue($1, forHTTPHeaderField: $0) })
        request.headers.forEach({ _request.addValue($1, forHTTPHeaderField: $0) })
        
        _request.httpBody = request.params.percentEncoded()
        
        return URLSession.shared
            .dataTaskPublisher(for: _request)
            .tryMap { (element) -> Data in
                guard let res = element.response as? HTTPURLResponse,
                      res.statusCode == 200 else { return Data() }
                return element.data
            }.decode(type: R.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.init(label: "tw.sabrina.PlayTaoyuan.api.call", qos: .default))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}




extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
