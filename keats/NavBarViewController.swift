//
//  NavBarViewController.swift
//  keats
//
//  Created by Swamita on 06/04/21.
//

import UIKit

class NavBarViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    static let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayView()
    }
    
    @IBAction func profileButtonClicked(_ sender: Any) {
    }
    
    func displayView() {
        NavBarViewController.vc.view.frame = UIApplication.shared.windows[0].frame
        NavBarViewController.vc.didMove(toParent: self)
        self.addChild(NavBarViewController.vc)
        self.view.addSubview(NavBarViewController.vc.view)
        self.view.bringSubviewToFront(navigationView)
    }

}
