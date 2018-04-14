//
//  IntroViewController.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var constantLogoViewVertical: NSLayoutConstraint!
    @IBOutlet weak var constantLogoViewTop: NSLayoutConstraint!
    @IBOutlet weak var constantLogoViewWidth: NSLayoutConstraint!
    @IBOutlet weak var constantLogoViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // move
        self.constantLogoViewWidth.constant  = 176
        self.constantLogoViewHeight.constant = 30
        self.constantLogoViewTop.constant = 27
        self.constantLogoViewVertical.isActive = false
        
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (isFinished) in
            if isFinished {
                self.performSegue(withIdentifier: "SegueHome", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
