//
//  MusicTableViewCell.swift
//  MusicSearch
//
//  Created by merdigon on 11/1/16.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
