//
//  SettingTableViewCell.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var lbeSubject: UILabel!
    @IBOutlet weak var lbeStorage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Update tableview cell
    ///
    /// - Parameter item: SettingItem
    func updateItem(_ item: SettingItem) {
        lbeSubject.text = item.subject
        lbeStorage.text = item.storedImagesStorage()
        if let detailText = item.detail {
            lbeStorage.text = detailText
            self.accessoryType = .disclosureIndicator
        }
    }

}
