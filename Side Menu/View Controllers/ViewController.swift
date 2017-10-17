//
//  ViewController.swift
//  Side Menu
//
//  Created by Westpac One Developer on 10/16/17.
//  Copyright © 2017 Westpac One Developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panOut = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        panOut.edges = .left
        view.addGestureRecognizer(panOut)
    }
    
    @IBAction func sideMenuButtonAction(sender: UIButton) {
        self.presentSideMenu()
    }
    
    func presentSideMenu() {
        let sideMenuTableViewController = self.storyboard!.instantiateViewController(withIdentifier :"SideMenuTableViewController") as! SideMenuTableViewController
        
        interactionController = UIPercentDrivenInteractiveTransition()
        sideMenuTableViewController.customTransitionDelegate.interactionController = interactionController
        
        self.present(sideMenuTableViewController, animated: true, completion: nil)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = translate.x / gesture.view!.bounds.size.width
        
        if gesture.state == .began {
            self.presentSideMenu()
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            let velocity = gesture.velocity(in: gesture.view)
            interactionController?.completionSpeed = 0.999  // https://stackoverflow.com/a/42972283/1271826
            if (percent > 0.5 && velocity.x == 0) || velocity.x > 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
}

