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
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }

    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("show_main", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController
        toViewController.transitioningDelegate = self.transitionManager
    }
}
