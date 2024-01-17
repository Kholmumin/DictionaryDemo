//
//  MeaningTableViewCell.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//

import UIKit

class MeaningTableViewCell: UITableViewCell {

    
    @IBOutlet weak var definition: UILabel!
    @IBOutlet weak var meaning: UILabel!
    @IBOutlet weak var mainWrapper: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainWrapper.layer.cornerRadius = 10
    }
}
