//
//  RequestProtocol.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import Foundation
import Combine
import SJUtil

public protocol RequestProtocol : NSObjectProtocol {
    
    associatedtype Response:JSONCodable
    
    var request:Request { get }
    
    func setClient(_ client:URLSessionClient) -> Self
    
    func excute() -> AnyPublisher<Response, Error>
}

public struct Request {
    let url:String
    
    var headers:[String:String] = [:]
    var params:[String:Any] = [:]
    var method:HttpMethod = .get
}
