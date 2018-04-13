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
    fileprivate enum PanGestureDirection: Int {
        case none = -1,
        up = 0,
        down,
        left,
        right
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    private var panningDirection = PanGestureDirection.none
    var panningStartPoint = CGPoint.zero
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
        
        // set pan gesture for action
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panScreen(_ :)))
        self.scrollView.addGestureRecognizer(panGesture)
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
    
    /// Check screen panning and do action by direction
    /// Horizontal: change image
    /// Vertical: close detail viewer
    ///
    /// - Parameter panGesture: PanGesture instance
    @objc func panScreen(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            if panningDirection == .none {
                // direction calculation
                let velocity = panGesture.velocity(in: panGesture.view)
                let isHorizontal = fabs(velocity.x) > fabs(velocity.y)
                if isHorizontal {
                    // horizontal
                    panningDirection = velocity.x > 0 ? .right : .left
                }else{
                    // vertical
                    panningDirection = velocity.y > 0 ? .down : .up
                }
                panningStartPoint = panGesture.location(in: panGesture.view)
            }
            break
            
        case .changed:
            switch panningDirection {
            case .up, .down:
                // vertical
                self.navigationController?.popViewController(animated: true)
                // FIXME: TEST - change direction state when image changed
                panningDirection = .none
                break
                
                // Horizontal
            case .left:
                if let nextItem = item?.nextItem {
                    loadItem(nextItem)
                    // FIXME: TEST - change direction state when image changed
                    panningDirection = .none
                }
                break
                
            case .right:
                if let preItem = item?.preItem {
                    loadItem(preItem)
                    // FIXME: TEST - change direction state when image changed
                    panningDirection = .none
                }
                break
                
            case .none:
                break
            }
            break
            
        case .ended, .failed, .cancelled:
            panningDirection = .none
            panningStartPoint = .zero
            break
            
        default:
            break
        }
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
