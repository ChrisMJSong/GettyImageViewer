//
//  DetailViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var item: HomeImageCellItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = item?.subject
        
        self.imageView.image = item?.imageObject.loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
