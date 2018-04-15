//
//  DetailViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import HTMLReader
import KRProgressHUD

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
        // show navigation default
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.scrollView.backgroundColor = UIColor.black
        
        // set tap gesture for hide navigation
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(toggleNavigationBar(_ :)))
        self.scrollView.addGestureRecognizer(tapGesture)
        
//        // set pan gesture for action
//        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panScreen(_ :)))
//        self.scrollView.addGestureRecognizer(panGesture)
        
        // set double tap gesture
        let doubleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapToZoom(_ :)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGesture)
        tapGesture.require(toFail: doubleTapGesture)
        
        let leftSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeImage(_ :)))
        leftSwipeGesture.direction = .left
        self.scrollView.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeImage(_ :)))
        rightSwipeGesture.direction = .right
        self.scrollView.addGestureRecognizer(rightSwipeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// save image to album
    ///
    /// - Parameter sender: UIBarButtonItem
    @IBAction func saveImage(_ sender: Any) {
        guard let image = self.imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func imageCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // save fail
            let alert = UIAlertController.init(title: nil, message: NSLocalizedString("Photo library access denied. If you want save image, Allow access to photo library access.", comment: "photo access denied."), preferredStyle: .alert)
            let actionSetting = UIAlertAction.init(title: NSLocalizedString("Settings", comment: "settings"), style: .cancel, handler: { (action) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            })
            alert.addAction(actionSetting)
            let actionOK = UIAlertAction.init(title: NSLocalizedString("OK", comment: "ok"), style: .default, handler: nil)
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        } else {
            KRProgressHUD.showSuccess()
        }
    }
    
    /// show image info
    ///
    /// - Parameter sender: UIBarButtonItem
    @IBAction func showInfo(_ sender: Any) {
        let alert = UIAlertController.init(title: self.title, message: self.item?.textContent, preferredStyle: .alert)
        let actionOK = UIAlertAction.init(title: NSLocalizedString("OK", comment: "ok"), style: .default, handler: nil)
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Load cell item
    ///
    /// - Parameter item: item instance
    func loadItem(_ item: HomeImageCellItem) {
        self.item = item
        self.title = item.subject
        self.imageView.image = item.imageObject.loadImage(.thumbnail, imageView: nil)
                
        // check has web contents
        if item.hasDetailContent() {
            if let image = item.imageObject.loadImage(.origin, imageView: self.imageView) {
                self.imageView.image = image
            }
        }else{
            // downlaod page source
            guard let contentUrlString = item.contentUrlString else {
                // show error
                return
            }
            NetworkManager.shared.loadGettyDetailpageSource(subUrl: contentUrlString, { (string, error) in
                guard let string = string else { return }
                
                // .firstNode is Magic key. always check first node
                let imageNode = [".product-image-container", ".firstNode", ".FrameArea", ".FrameBorder", ".Frame", ".innerFrame", ".innerImageArea"]
                let nodes = [".prodpanelright", ".proddetails"]
                let element = HTMLParser.elementFromHTMLString(string)
                let imageElements = HTMLParser.subElementsFromHTMLElement(element, nodeNames: imageNode)
                let descriptionElements = HTMLParser.subElementsFromHTMLElement(element, nodeNames: nodes)
                
                let imageUrl = imageElements?[0].childElementNodes[0].attributes["src"]
                let detailText = descriptionElements?[0].childElementNodes[4].textContent
                
                self.item?.imageObject.originImageUrlString = imageUrl
                self.item?.textContent = detailText
                
                // get image
                if let image = item.imageObject.loadImage(.origin, imageView: self.imageView) {
                    self.imageView.image = image
                }
            })
        }
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
        // self.scrollView.backgroundColor = isHidden ? UIColor.white : UIColor.black
    }
    
    @objc func tapToZoom(_ gesture: UITapGestureRecognizer) {
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            // zoom to original
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }else {
            // move to touch point
            let touchLocation = gesture.location(in: gesture.view)
            let size = (gesture.view?.frame.size)!
            var targetLocation = CGPoint.zero
            targetLocation.x = (touchLocation.x / size.width) * size.width - size.width / 2
            targetLocation.y = (touchLocation.y / size.height) * size.height - size.height / 2
            
            self.scrollView.setContentOffset(targetLocation, animated: false)
            
            // zoom to 2x
            self.scrollView.setZoomScale(2.0, animated: true)
        }
    }
    
    @objc func swipeImage(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            if let nextItem = item?.nextItem {
                loadItem(nextItem)
            }
            break
        case UISwipeGestureRecognizerDirection.right:
            if let preItem = item?.preItem {
                loadItem(preItem)
            }
            break
        default:
            break
        }
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
