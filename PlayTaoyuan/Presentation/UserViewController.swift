//
//  UserViewController.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import UIKit
import SafariServices

class UserViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    let dataSource:[[String]] = [["我的帳號","語言更換","隱私設定"],["我的收藏"],["最新消息","關於我們"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "User"
        initTableView()
    }

    private func initTableView() {
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    private func showWeb() {
        let web = SFSafariViewController(url: URL(string: "https://www.google.com.tw")!)
        self.navigationController?.present(web, animated: true, completion: nil)
    }
    
    private func showWeb2() {
        let web = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        web.url = "https://www.google.com.tw"
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.show(web, sender: nil)
    }
}

extension UserViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == dataSource.count-1, indexPath.row == 1 {
            showWeb()
        }else if indexPath.section == dataSource.count-1, indexPath.row == 0 {
            showWeb2()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return "系統"
        case 1:
            return "收藏"
        default:
            return "個人"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == dataSource.count-1 else {
            return nil
        }
        return "\nA privacy policy is a statement or legal document (in privacy law) that discloses some or all of the ways a party gathers, uses, discloses, and manages a customer or client's data. ... Their privacy laws apply not only to government operations but also to private enterprises and commercial transactions."
    }
}
