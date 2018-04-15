//
//  SettingViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static let reuseCellIdentifier = "SettingCell"
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        // storege management
        let item = SettingItem()
        item.subject = NSLocalizedString("Delete all downlad image files", comment: "")
        viewModel.addItem(item)
        let item2 = SettingItem()
        item2.subject = NSLocalizedString("Cache", comment: "")
        viewModel.addItem(item2)
    }
}

// MARK: UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewController.reuseCellIdentifier) as! SettingTableViewCell
        cell.updateItem(viewModel.item(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section)
    }
}

// MARK: UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
}
