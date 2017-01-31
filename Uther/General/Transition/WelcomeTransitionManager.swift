//
//  WelcomeTransitionManager.swift
//  Uther
//
//  Created by why on 8/8/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

class WelcomeTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    // MARK: UIViewControllerAnimatedTransitioning
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // avatar
        let fromAvatar  = fromView.viewWithTag(1001)!
        let toAvatar    = toView.viewWithTag(1002)!
        
        let avatar = fromAvatar.snapshotView(afterScreenUpdates: true)
        avatar?.frame = fromAvatar.frame
        container.addSubview(avatar!)
        
        fromAvatar.alpha = 0
        toAvatar.alpha = 0
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
                avatar?.frame = toAvatar.frame
            },
            completion: { finished in
                fromView.alpha = 1
                fromAvatar.alpha = 1
                toAvatar.alpha = 1
                avatar?.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
