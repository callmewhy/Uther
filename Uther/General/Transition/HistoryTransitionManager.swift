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
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
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
        let avatar = fromAvatar.snapshotView(afterScreenUpdates: true)
        container.addSubview(avatar!)
        avatar?.frame = fromView.convert(fromAvatar.frame, to: container)
        fromAvatar.alpha = 0
        toAvatar.alpha = 0
        let targetFrame = toView.convert(toAvatar.frame, to: container)
        
        // view
        let offsetY = abs(fromAvatar.height - toAvatar.height)
        let offScreenBottom = CGAffineTransform(translationX: 0, y: offsetY)
        let duration = self.transitionDuration(using: transitionContext)

        if isPresenting {
            toView.alpha = 0
            toView.transform = offScreenBottom
        }
        
        UIView.animate(withDuration: duration,
            animations: {
                avatar?.frame = targetFrame
                toView.alpha = 1
                toView.transform = CGAffineTransform.identity
                if !self.isPresenting {
                    fromView.alpha = 0
                    fromView.transform = offScreenBottom
                }
            },
            completion: { finished in
                fromView.alpha = 1
                fromAvatar.alpha = 1
                toAvatar.alpha = 1
                fromView.transform = CGAffineTransform.identity
                toView.transform = CGAffineTransform.identity
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
        isPresenting = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
