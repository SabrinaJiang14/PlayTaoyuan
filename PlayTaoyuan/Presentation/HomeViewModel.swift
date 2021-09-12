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

    @Published var dataSource:[[String]] = []
    
    
    private let repo :Repository
    init(repo:Repository = Repository()) {
        self.repo = repo
    }
    
    func viewDidLoad() {
        dataSource.append((0..<11).map({ String($0) }))
        dataSource.append((0..<11).map({ String($0) }))
    }
}

