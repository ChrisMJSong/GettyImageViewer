//
//  HomeViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 12/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate let cellIdentifier = "ImageCell"
    fileprivate let itemPerRow = 3
//    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let homeViewModel = HomeViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = homeViewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "SegueDetail", sender: item)
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
        let cellPadding: CGFloat = 2;
        let itemWidth = (collectionView.frame.size.width - cellPadding) / CGFloat(itemPerRow)
        
        return CGSize.init(width: itemWidth, height: itemWidth)
    }
}
