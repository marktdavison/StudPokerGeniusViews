//
//  SocialTableViewCell.swift
//  DeckOfCards
//
//  Created by Mark Davison on 02/06/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class SocialTableViewCell: UITableViewCell {
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var socialImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
