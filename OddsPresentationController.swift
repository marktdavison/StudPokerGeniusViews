//
//  OddsPresentationController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 19/08/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit

class OddsPresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    var dimmingView = UIView()
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }

    override init(presentedViewController: UIViewController, presenting presentingViewContoller: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewContoller)
        
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        dimmingView.alpha = 0
        
        
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = self.containerView!.bounds
        dimmingView.alpha = 0
        containerView?.insertSubview(dimmingView, at: 0)
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in self.dimmingView.alpha = 1}, completion: nil)
        }else{
            dimmingView.alpha = 1
        }
    
    }
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }else{
            dimmingView.alpha = 0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        if let containerBounds = containerView?.bounds {
            dimmingView.frame = containerBounds
            presentedView?.frame = containerBounds
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .overFullScreen
    }

}
