//
//  InfoPageViewController.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import UIKit
import WebKit

class InfoPageViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var pageView: WKWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set self as the navigation delegate so we get load-start and load-finish callbacks
                pageView.navigationDelegate = self
                
                // build the URL and load it
                if let siteURL = URL(string: "https://www.dominos.ca") {
                    let request = URLRequest(url: siteURL)
                    pageView.load(request)
                }
    }
    // MARK: - WKNavigationDelegate — page starts loading
        
        func webView(_ webView: WKWebView,
                     didStartProvisionalNavigation navigation: WKNavigation!) {
            spinner.isHidden = false
            spinner.startAnimating()
        }
        
        // MARK: - WKNavigationDelegate — page finished loading
        
        func webView(_ webView: WKWebView,
                     didFinish navigation: WKNavigation!) {
            spinner.stopAnimating()
            spinner.isHidden = true
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
