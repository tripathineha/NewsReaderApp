//
//  SplashViewController.swift
//  NewsreaderApp
//
//  Created by Neha Tripathi on 01/02/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var splashTimer : Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        splashTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(removeSplash), userInfo: nil, repeats: false)
    }
    
    @objc func removeSplash()
    {   self.dismiss(animated: true, completion: {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.pushViewController(viewController, animated: true)
    })
    }

    deinit{
        if let timer = splashTimer {
            timer.invalidate()
        }
    }

}
