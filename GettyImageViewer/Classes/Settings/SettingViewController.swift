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
        viewModel.delegate = self
        viewModel.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        if let action = item.action {
            action()
        }
    }
}
