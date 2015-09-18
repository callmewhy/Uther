//
//  HistoryTransitionManager.swift
//  Uther
//
//  Created by why on 8/8/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
class HistoryTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var isPresenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        if isPresenting {
            container.addSubview(fromView)
            container.addSubview(toView)
        } else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        
        // avatar
        let fromAvatar  = isPresenting ? fromView.viewWithTag(1002)! : fromView.viewWithTag(1003)!
        let toAvatar    = isPresenting ? toView.viewWithTag(1003)! : toView.viewWithTag(1002)!
        let avatar = fromAvatar.snapshotViewAfterScreenUpdates(true)
        container.addSubview(avatar)
        avatar.frame = fromView.convertRect(fromAvatar.frame, toView: container)
        fromAvatar.alpha = 0
        toAvatar.alpha = 0
        let targetFrame = toView.convertRect(toAvatar.frame, toView: container)
        
        // view
        let offsetY = abs(fromAvatar.height - toAvatar.height)
        let offScreenBottom = CGAffineTransformMakeTranslation(0, offsetY)
        let duration = self.transitionDuration(transitionContext)

        if isPresenting {
            toView.alpha = 0
            toView.transform = offScreenBottom
        }
        
        UIView.animateWithDuration(duration,
            animations: {
                avatar.frame = targetFrame
                toView.alpha = 1
                toView.transform = CGAffineTransformIdentity
                if !self.isPresenting {
                    fromView.alpha = 0
                    fromView.transform = offScreenBottom
                }
            },
            completion: { finished in
                fromView.alpha = 1
                fromAvatar.alpha = 1
                toAvatar.alpha = 1
                fromView.transform = CGAffineTransformIdentity
                toView.transform = CGAffineTransformIdentity
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
        isPresenting = true
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
