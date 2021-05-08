//
//  loadImage.swift
//  keats
//
//  Created by Swamita on 08/05/21.
//

import Foundation
import UIKit.UIImageView

extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
