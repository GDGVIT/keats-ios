//
//  ReadViewController.swift
//  keats
//
//  Created by Swamita on 07/05/21.
//

import UIKit
import WebKit

class ReadViewController: UIViewController, WKNavigationDelegate,  WKUIDelegate  {
    
    var webView: WKWebView!
    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var pageChatButton: UIButton!
    var clubId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarColor(view: view)
        guard let idToken = UserDefaults.standard.string(forKey: "JWToken") else {return}
        guard let userId = UserDefaults.standard.string(forKey: "id") else {return}
        guard let url = URL(string: "https://keats.pages.dev/club/\(clubId)/read?token=\(idToken)&userId=\(userId)")
        else {
            print("Incorrect URL for book")
            return
        }
        print("Read URL: \(url)")
        let request = URLRequest(url: url)
            let webView = WKWebView(frame: self.readView.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight] //It assigns Custom View height and width
            webView.navigationDelegate = self
        
        webView.contentMode = .scaleAspectFit
            webView.load(request)
            self.readView.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pageChatTapped(_ sender: Any) {
    }
    
    @IBAction func clubChatTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.absoluteString {
            if host.contains("keats.pages.dev/profile") {
                print("Yes sirr")
                decisionHandler(.cancel)
                return
            } else {
                print("no sir")
                decisionHandler(.allow)
            }
        }

    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if let hostUrl = request.url?.absoluteString {
            if hostUrl.contains("keats.pages.dev/profile")  {
                print("profile")
                performSegue(withIdentifier: "readToProfile", sender: self)
                return false
            }
        }
        
        if let hostUrl = request.url?.absoluteString {
            if hostUrl.contains("keats.pages.dev/clubs") {
                navigationController?.popToRootViewController(animated: true)
                return false
            }
        }

            return true
        }
}
