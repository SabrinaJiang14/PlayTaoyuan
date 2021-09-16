//
//  WebViewController.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/13.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var url:String = ""
    
    private var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([webView.topAnchor.constraint(equalTo: view.topAnchor),
                                     webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        webView.load(URLRequest(url: URL(string: url)!))
    }

}
