//
//  TutorialViewController.swift
//  HousingSensei
//
//  Created by Roger Wang on 12/2/19.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class TutorialViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        let url = URL(string: "https://www.apartmentlist.com/rentonomics/8-tips-finding-apartment-can-afford/")!
        
        DispatchQueue.global().async {
          
            self.webView.load(URLRequest(url: url))
            
            DispatchQueue.main.async {
               // self.loading.stopAnimating()
               // self.loading.isHidden = true
            
                //self.trendingCollectionView.reloadData()
            }
        }
        webView.load(URLRequest(url: url))
          
        // 2
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    //title = webView.title
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
