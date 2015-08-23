//
//  ViewController.swift
//  RepairMan
//
//  Created by liuyan on 8/16/15.
//  Copyright © 2015 ABRS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var launchImageView: UIImageView!
    var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    
    internal func loadSubViews() {
        self.launchImageView = UIImageView(frame:CGRectZero)
        self.view.addSubview(self.launchImageView)
        
        self.nextButton = UIButton(frame: CGRectZero)
        self.view.addSubview(self.nextButton)
    }
    
}

