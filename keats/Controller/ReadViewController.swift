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
    var clubId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarColor(view: view)
        guard let idToken = UserDefaults.standard.string(forKey: "JWToken") else {return}
        guard let url = URL(string: "https://keats.pages.dev/club/\(clubId)/read?token=\(idToken)") else {
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
    
}
