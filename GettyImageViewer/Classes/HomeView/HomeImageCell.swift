//
//  HomeImageCell.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class HomeImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var item: HomeImageCellItem?
    
    func updateItem(item: HomeImageCellItem) {
        self.item = item
        self.imageView.image = item.imageObject.loadImage(.thumbnail, imageView: self.imageView)
    }
}
