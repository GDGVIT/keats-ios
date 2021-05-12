//
//  CommentTableViewCell.swift
//  keats
//
//  Created by Swamita on 12/05/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var yourImageView: UIImageView!
    @IBOutlet weak var theirImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
