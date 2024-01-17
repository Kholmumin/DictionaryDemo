//
//  SynTableViewCell.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//

import UIKit

class SynTableViewCell: UITableViewCell {

    @IBOutlet weak var synonim: UILabel!
    @IBOutlet weak var anty: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        
        
    }

   
    
}
