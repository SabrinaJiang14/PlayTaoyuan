//
//  Repository.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import Foundation
import Combine
import SJUtil

class Repository:NSObject {
    
    
    let client:URLSessionClient
    
    override init() {
        client = URLSessionClient()
            .setBaseUrl("https://travel.tycg.gov.tw/open-api")
            .setHeaders(["Accept":"application/json"])
    }
}


extension Repository {
    
    func getAttraction() -> AnyPublisher<AttractionDatabean, Error> {
        return AttractionRequest()
            .setClient(client)
            .excute()
    }
    
    func getTours() -> AnyPublisher<ToursDataBean, Error> {
        return TourRequest()
            .setClient(client)
            .excute()
    }
}
