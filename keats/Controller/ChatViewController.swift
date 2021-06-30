//
//  ChatViewController.swift
//  keats
//
//  Created by Swamita on 30/06/21.
//

import UIKit
import WebKit

class ChatViewController: UIViewController, WKNavigationDelegate,  WKUIDelegate {
    
    var webView: WKWebView!
    @IBOutlet weak var readView: UIView!
    var clubId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarColor(view: view)
        
        guard let idToken = UserDefaults.standard.string(forKey: "JWToken") else {return}
        guard let url = URL(string: "https://keats.pages.dev/club/\(clubId)/chat?token=\(idToken)") else {
            print("Incorrect URL for chat")
            return
        }
        print("Chat URL: \(url)")
        let request = URLRequest(url: url)
            let webView = WKWebView(frame: self.readView.bounds)
        webView.autoresizingMask = [.flexibleWidth, ] //It assigns Custom View height and width
            webView.navigationDelegate = self
        
        webView.contentMode = .scaleAspectFit
            webView.load(request)
            self.readView.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
