//
//  ClubTableViewCell.swift
//  keats
//
//  Created by Swamita on 29/04/21.
//

import UIKit

class ClubTableViewCell: UITableViewCell {

    @IBOutlet weak var clubImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
