//
//  DetailViewController.swift
//  WhitePaper
//
//  Created by Yunus Emre Bayezit on 25.12.2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var news = ["www.ntv.com.tr","webtekno.com","donanimhaber.com","shiftdelete.net"]
    var selectedNews: String = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url=URL(string:"https://" + selectedNews)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer=UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action:nil)
        let refresh=UIBarButtonItem(barButtonSystemItem: .refresh, target:webView, action:#selector(webView.reload))
        
        let goBack=UIBarButtonItem(barButtonSystemItem: .done ,target: webView,action:#selector(webView.goBack))
        let goForward=UIBarButtonItem(barButtonSystemItem: .fastForward,target: webView,action:#selector(webView.goForward))

        toolbarItems = [progressButton, spacer, refresh,goBack,goForward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new,context: nil)
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        
        for website in news{
            ac.addAction(UIAlertAction(title:website , style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in news {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
 
}
