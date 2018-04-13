//
//  DetailViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    fileprivate let animateTime = 0.25

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var item: HomeImageCellItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = item {
            self.loadItem(item)
        }
        
        // set tap gesture for hide navigation
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(toggleNavigationBar(_ :)))
        self.scrollView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Load cell item
    ///
    /// - Parameter item: item instance
    func loadItem(_ item: HomeImageCellItem) {
        self.item = item
        self.title = item.subject
        self.imageView.image = item.imageObject.loadImage()
    }
    
    /// Hide navigation bar and toolbar when tapped
    ///
    /// - Parameter gesture: TapGesture instance
    @objc func toggleNavigationBar(_ gesture: UITapGestureRecognizer) {
        guard let isHidden = self.navigationController?.isNavigationBarHidden else {
            return
        }
        self.navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        
        // Hide toolbar animation
        let animateTime = isHidden ? self.animateTime : 0
        UIView.animate(withDuration: animateTime) {
            self.toolBar.alpha = CGFloat(isHidden ? 1 : 0)
        }
        
        // change background color
        self.scrollView.backgroundColor = isHidden ? UIColor.white : UIColor.black
    }

    /// Hide statusbar when full screen imaging
    override var prefersStatusBarHidden: Bool {
        guard let currentState = self.navigationController?.isNavigationBarHidden else {
            return false
        }
        return currentState
    }
}

// MARK: UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
