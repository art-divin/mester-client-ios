//
//  TableViewCell.swift
//  Mester
//
//  Created by Ruslan Alikhamov on 26/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		if (selected) {
			self.backgroundColor = ThemeDefault.colorForCellBg(.Active)
		} else {
			self.backgroundColor = ThemeDefault.colorForCellBg(.Inactive)
		}
    }

}
