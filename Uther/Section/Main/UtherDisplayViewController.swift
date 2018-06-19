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

// News update event
enum EventType: CustomStringConvertible {
    // error
    case error
    // Set Avatar
    case avatar(ImageName)
    // Set expression
    case emoji(PositiveValue)
    // Set text
    case text(String)
    
    var description: String {
        get {
            switch self {
            case .error:
                return "Error"
            case let .avatar(i):
                return "Avatar:\(i)"
            case let .emoji(p):
                return "Emoji(\(p))"
            case let .text(t):
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func updateWithEventType(_ event: EventType) {
        log.debug(event.description)
        switch event {
        case let .avatar(imageName):
            avatarImageView.image = UIImage(named: imageName)
        case let .emoji(p):
            messageLabel.text = p.emoji + (debug ? " \(p)" : "")
            messageLabel.morphingEffect = LTMorphingEffect.next()
        case let .text(text):
            messageLabel.text = text
        case .error:
            messageLabel.text = "_(:з」∠)_" + (debug ? " error" : "")
        }
    }

    let transitionManager = HistoryTransitionManager()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_history" {
            let toViewController = segue.destination
            toViewController.transitioningDelegate = self.transitionManager
        }

    }
    @IBAction func avatarTapped(_ sender: AnyObject) {
        let vc = self.parent! as! MainViewController
        if vc.keyboardShowing {
            vc.view!.endEditing(true)
            Async.main(after: 0.3) {
                self.performSegue(withIdentifier: "show_history", sender: sender)
            }
        } else {
            self.performSegue(withIdentifier: "show_history", sender: sender)
        }
    }
}

extension UtherDisplayViewController: LTMorphingLabelDelegate {
    func morphingDidStart(_ label: LTMorphingLabel) {

    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {

    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, _ progress: Float) {

    }
}
