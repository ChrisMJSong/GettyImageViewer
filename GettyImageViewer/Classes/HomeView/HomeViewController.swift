//
//  HomeViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 12/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import RxSwift
import Reachability
import SVProgressHUD

class HomeViewController: UIViewController {

    let themeColor = UIColor(red:0.00, green:0.43, blue:0.99, alpha:1.00)
    fileprivate let cellIdentifier = "ImageCell"
    
    let homeViewModel = HomeViewModel()
    var disposedBag = DisposeBag()
    
    @IBOutlet weak var barItemRefresh: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        // load initial page
        reloadView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "SegueDetail"?:
            let viewController = segue.destination as! DetailViewController
            if let item = sender as? HomeImageCellItem {
                viewController.item = item
            }
            
        default:
            break
        }
    }
    
    /// set up
    func setup(){
//        self.title = NSLocalizedString("Getty Image Gallary", comment: "Home View Title")
        // remove firstview
        self.navigationItem.hidesBackButton = true
        self.navigationController?.viewControllers.remove(at: 0)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let image = UIImage.init(named: "logo_t")
        let imageView = UIImageView.init(image: image)
        self.navigationItem.titleView = imageView
        
        SVProgressHUD.setForegroundColor(themeColor)
    }
    
    /// reload data from getty server
    func reloadView(){
        // check reachable
        let reachability = Reachability()!
        
        // Network has no connection
        if reachability.connection == .none
        {
            let message = NSLocalizedString("To access to the data, turn off airplane mode or use Wi-Fi.", comment: "Network no connection")
            let actionSettings = UIAlertAction.init(title: NSLocalizedString("Settings", comment: "ButtonTitleSettings"), style: .cancel, handler: { (action) in
                guard let url = URL.init(string: "App-prefs:root=WIFI") else {
                    return
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            })
            let actionOK = UIAlertAction.init(title: NSLocalizedString("OK", comment: "ok"), style: .default, handler: nil)
            self.showAlert(message, alertActions: actionSettings, actionOK)
            return
        }
        
        // download list
        NetworkManager.shared.loadGettyMainPageSource { (result, error) in
            
            guard error == nil, let result = result else {
                // show Error message
                let message = (error?.localzedDescription())! + NSLocalizedString(" Please try again in a few minutes.", comment: "try again message")
                self.showDefaultAlert(message)
//                throw error
                return
            }
            
            let nodeNames = [".fullwidthbordertop", ".gallery-wrap", ".gallery-item-group"]
            let element = HTMLParser.elementFromHTMLString(result)
            let elements = HTMLParser.subElementsFromHTMLElement(element, nodeNames: nodeNames)
            
            if let elements = elements {
                self.homeViewModel.replaceItemsByHTMLElements(elements)
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func showDefaultAlert(_ message: String) {
        let actionOK = UIAlertAction.init(title: NSLocalizedString("OK", comment: "ok"), style: .default, handler: nil)
        self.showAlert(message, alertActions: actionOK)
    }
    
    func showAlert(_ message: String, alertActions: UIAlertAction...) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        for action in alertActions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    class func itemPerRow() -> CGFloat {
        var itemPerRow: CGFloat = 7
        
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                itemPerRow = 4
            case .pad, .carPlay:
                itemPerRow = 5
            default:
                break
            }
            
        default:
            break
        }
        
        return itemPerRow
    }
    
    @IBAction func reloadAlbum(_ sender: Any) {
        self.reloadView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        layout.invalidateLayout()
        
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = homeViewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "SegueDetail", sender: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListFooter", for: indexPath)
        let pLabel = view.subviews.last as! UILabel
        pLabel.text = homeViewModel.footerMessage()
        
        return view
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return homeViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeImageCell
        
        let item = homeViewModel.item(at: indexPath.row)
        cell.backgroundColor = UIColor.lightGray
        cell.updateItem(item: item)
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPadding: CGFloat = CGFloat(HomeViewController.itemPerRow() * 2 - 2);
        let itemWidth = (collectionView.frame.size.width - cellPadding) / CGFloat(HomeViewController.itemPerRow())
        
        return CGSize.init(width: itemWidth, height: itemWidth)
    }
}
