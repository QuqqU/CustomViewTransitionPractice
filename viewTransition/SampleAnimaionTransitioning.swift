//
//  SampleAnimaionTransitioning.swift
//  viewTransition
//
//  Created by 정기웅 on 2018. 4. 5..
//  Copyright © 2018년 정기웅. All rights reserved.
//

import UIKit

class SampleAnimaionTransitioning: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    let modalviewYOffset: CGFloat = 44.0
    let nonModalViewScale: CGFloat = 0.9
    let nonModalViewAlpha: CGFloat = 0.6

    let timeDuration: TimeInterval = 1.0
    var isSubVCOn = false

    var transitionContext: UIViewControllerContextTransitioning!
    var toView: UIView!
    var fromViewHeight: CGFloat = 0
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeDuration
    }
    
    func addGestureRecognizersToView(_ selfView: UIView, naviView: UIView) {
        self.toView = selfView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(recognizer:)))
        naviView.addGestureRecognizer(panGesture)
    }
    @objc func pan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began { recognizer.setTranslation(.zero, in: self.toView.superview) }
        if recognizer.translation(in: self.toView).y < 0.1 { return }
        
        let percentage = recognizer.translation(in: self.toView).y / self.toView.bounds.height
        let scaleFactor: CGFloat = self.nonModalViewScale + (1 - self.nonModalViewScale) * percentage
        let alphaVal: CGFloat = self.nonModalViewAlpha + (1 - self.nonModalViewAlpha) * percentage
        
        
        guard let fromViewController: UIViewController = self.transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController: UIViewController = self.transitionContext.viewController(forKey: .to) else { return }
        
        
        fromViewController.view.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor,
                                                                                y: scaleFactor)
        fromViewController.view.alpha = alphaVal
        toViewController.view.frame.origin.y = percentage * self.toView.frame.height + self.modalviewYOffset
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            guard let recognizerView = recognizer.view else { return }
        
            let velocityY: CGFloat = recognizer.velocity(in: recognizerView.superview).y
            let cancelUp: Bool = (velocityY < 0) || (velocityY == 0 && recognizerView.frame.origin.y < self.toView.bounds.height / 2)
            let points: CGFloat = cancelUp ? recognizerView.frame.origin.y : self.toView.bounds.height - recognizerView.frame.origin.y
            
            var duration: TimeInterval = TimeInterval(points / velocityY)
            
            if duration < 0.2 { duration = 0.2 }
            else if duration > 0.4 { duration = 0.4 }
            
            if cancelUp == true { self.moveModalView(duration: duration) }
            else { toViewController.dismiss(animated: true, completion: nil) }
            
        }
    }
    func moveModalView(duration: TimeInterval) {
        guard let fromViewController: UIViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController: UIViewController = transitionContext.viewController(forKey: .to) else { return }
        var modalViewControllerFrame: CGRect = toViewController.view.frame
        modalViewControllerFrame.origin.y = self.modalviewYOffset
        let transformVal: CGAffineTransform = CGAffineTransform(scaleX: self.nonModalViewScale, y: self.nonModalViewScale)
        let alphaVal: CGFloat = self.nonModalViewAlpha
        
        UIView.animate(withDuration: duration,
                       animations: {
                        toViewController.view.frame = modalViewControllerFrame
                        fromViewController.view.transform = transformVal
                        fromViewController.view.alpha = alphaVal
        })
    }
    
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        let container = transitionContext.containerView
        let modalVC = self.isSubVCOn ? fromVC : toVC
        let nonModalVC = self.isSubVCOn ? toVC : fromVC
        self.transitionContext = transitionContext
        fromViewHeight = fromVC.view.frame.height
        
        let finalVCFrame = transitionContext.finalFrame(for: toVC)
        var modalFinalFrame = self.isSubVCOn ? finalVCFrame.offsetBy(dx: 0, dy: fromViewHeight) : finalVCFrame
        
        
        var scaleFactor: CGFloat, alphaVal: CGFloat
        if self.isSubVCOn {
            scaleFactor = 1
            alphaVal = 1
        }
        else {
            modalVC.view.frame = finalVCFrame.offsetBy(dx: 0, dy: fromViewHeight)
            modalFinalFrame.origin.y += self.modalviewYOffset
            
            scaleFactor = self.nonModalViewScale
            alphaVal = self.nonModalViewScale
            
            container.addSubview(toVC.view)
        }
        
        UIView.animate(withDuration: timeDuration,
                       animations: {
                        nonModalVC.view.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
                        nonModalVC.view.alpha = alphaVal
                        modalVC.view.frame = modalFinalFrame
        },
                       completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        self.isSubVCOn = !self.isSubVCOn
        })
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
 
}
