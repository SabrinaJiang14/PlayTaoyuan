//
//  HomeViewModel.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import Foundation
import UIKit
import Combine

class HomeViewModel:NSObject {

    @Published var dataSource:[Attraction]?
    @Published var load:Bool = true
    
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    private let repo :Repository
    
    init(repo:Repository = Repository()) {
        self.repo = repo
    }
    
    func viewDidLoad() {
        repo
            .getAttraction()
            .sink(receiveCompletion: { _ in }) { datas in
                self.load = false
                
                var data:[Attraction] = []
                
                if datas.infos.info.count > 7 {
                    data.append(Attraction(cellIdentifier: "SingleLayoutCell",
                                           info: datas.infos.info[0..<3].map({ $0 })))
                    data.append(Attraction(cellIdentifier: "ThreeRowsLayoutCell",
                                           info: datas.infos.info[3..<7].map({ $0 })))
                    data.append(Attraction(cellIdentifier: "SingleLayoutCell",
                                           info: datas.infos.info[7...].map({ $0 })))
                }
                
                self.dataSource = data
            }.store(in: &cancellables)
    }
}


struct Attraction {
    var cellIdentifier:String
    var info:[Info]
}
