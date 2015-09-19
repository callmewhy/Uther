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
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // avatar
        let fromAvatar  = fromView.viewWithTag(1001)!
        let toAvatar    = toView.viewWithTag(1002)!
        fromView
        let avatar = fromAvatar.snapshotViewAfterScreenUpdates(true)
        avatar.frame = fromAvatar.frame
        container.addSubview(avatar)
        
        fromAvatar.alpha = 0
        toAvatar.alpha = 0
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: {
                fromView.alpha = 0
                avatar.frame = toAvatar.frame
            },
            completion: { finished in
                fromView.alpha = 1
                fromAvatar.alpha = 1
                toAvatar.alpha = 1
                avatar.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
