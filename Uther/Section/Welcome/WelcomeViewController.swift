//
//  WelcomeViewController.swift
//  Uther
//
//  Created by why on 8/8/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    let transitionManager = WelcomeTransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "show_main", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination
        toViewController.transitioningDelegate = self.transitionManager
    }
}
