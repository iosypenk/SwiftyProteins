//
//  ProteinListCell.swift
//  SwiftyProteins
//
//  Created by Maxym RYBAK on 9/9/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit

class ProteinListCell: UITableViewCell {

    @IBOutlet weak var proteinName: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(name: String) {
        cellView.layer.cornerRadius = 10
        proteinName.text = name
        self.backgroundColor = UIColor(red: 73/255, green: 82/255, blue: 92/255, alpha: 1)
        cellView.backgroundColor = UIColor(red: 59/255, green: 73/255, blue: 91/255, alpha: 1)
    }
    
}
