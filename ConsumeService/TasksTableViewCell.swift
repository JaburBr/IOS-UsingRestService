//
//  TasksTableViewCell.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/8/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgComplete: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
