//
//  PostsTableViewCell.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 06/05/24.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var labelPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
