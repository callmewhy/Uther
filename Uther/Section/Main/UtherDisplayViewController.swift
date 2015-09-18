//
//  UtherDisplayViewController.swift
//  Uther
//
//  Created by why on 7/29/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import LTMorphingLabel
import Async

// 消息更新的事件
enum EventType: CustomStringConvertible {
    // 错误
    case Error
    // 设置头像
    case Avatar(ImageName)
    // 设置表情
    case Emoji(PositiveValue)
    // 设置文字
    case Text(String)
    
    var description: String {
        get {
            switch self {
            case Error:
                return "Error"
            case let Avatar(i):
                return "Avatar:\(i)"
            case let Emoji(p):
                return "Emoji(\(p))"
            case let Text(t):
                return "Text:\(t)"
            }
        }
    }
}

class UtherDisplayViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func updateWithEventType(event: EventType) {
        log.debug(event.description)
        switch event {
        case let .Avatar(imageName):
            avatarImageView.image = UIImage(named: imageName)
        case let .Emoji(p):
            messageLabel.text = p.emoji + (debug ? " \(p)" : "")
            messageLabel.morphingEffect = LTMorphingEffect.next()
        case let .Text(text):
            messageLabel.text = text
        case .Error:
            messageLabel.text = "_(:з」∠)_" + (debug ? " error" : "")
        }
    }

    let transitionManager = HistoryTransitionManager()
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show_history" {
            let toViewController = segue.destinationViewController
            toViewController.transitioningDelegate = self.transitionManager
        }

    }
    @IBAction func avatarTapped(sender: AnyObject) {
        let vc = self.parentViewController! as! MainViewController
        if vc.keyboardShowing {
            vc.view!.endEditing(true)
            Async.main(after: 0.3) {
                self.performSegueWithIdentifier("show_history", sender: sender)
            }
        } else {
            self.performSegueWithIdentifier("show_history", sender: sender)
        }
    }
}

extension UtherDisplayViewController: LTMorphingLabelDelegate {
    func morphingDidStart(label: LTMorphingLabel) {

    }
    
    func morphingDidComplete(label: LTMorphingLabel) {

    }
    
    func morphingOnProgress(label: LTMorphingLabel, _ progress: Float) {

    }
}