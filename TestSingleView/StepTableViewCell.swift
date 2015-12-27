//
//  StepTableViewCell.swift
//  TestSingleView
//
//  Created by footruck on 12/2/15.
//  Copyright © 2015 footruck. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    // the corresponding stage and step id for this cell
    var stageId = 0
    var stepId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
