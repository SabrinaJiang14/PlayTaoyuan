//
//  ListViewController.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import UIKit
import Combine

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var vm:DatabaseProtocol! = CoreDataViewModel()
    
    var dataSource:[StoreProtocol] = []
    
    var cancellable:AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initTable()
        initBind()
        
    }

    func initBind() {
        cancellable = vm.storesPublisher.sink(receiveCompletion: { _ in }) { datas in
            self.dataSource = datas
            self.tableView.reloadData()
        }
        
        vm.viewDidLoad()
    }
    
    func initTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        dataSource.removeAll()
        cancellable = nil
        if sender.selectedSegmentIndex == 0 {
            vm = CoreDataViewModel()
        }else{
            vm = RealmViewModel()
        }
        initBind()
    }
    
    @IBAction func tapCreateAction(_ sender: UIButton) {
        vm.createStore()
    }
    
    @IBAction func tapDeleteAction(_ sender: UIButton) {
        if let index = tableView.indexPathForSelectedRow {
            vm.deleteStore(index: index)
        }
    }
}

extension ListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].getName()
        cell.detailTextLabel?.text = dataSource[indexPath.row].getPhone() + "\t" + dataSource[indexPath.row].getAddress()
        return cell
    }
}




