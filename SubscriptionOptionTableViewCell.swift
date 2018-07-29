//
//  SubscriptionOptionTableViewCell.swift
//  DeckOfCards
//
//  Created by Mark Davison on 28/07/2018.
//  Copyright © 2018 anditwasso. All rights reserved.
//

import UIKit

class SubscriptionOptionTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var yourPlanLabel: UILabel!
    
    var isCurrentPlan: Bool = false {
        didSet {
  //          yourPlanLabel.isHidden = !isCurrentPlan
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1369239688, green: 0.1614148617, blue: 0.1697000265, alpha: 1)
        selectedBackgroundView = view
        yourPlanLabel.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        yourPlanLabel.isHidden = true
    }

}
