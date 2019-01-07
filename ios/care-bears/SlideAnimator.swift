//
//  SlideAnimator.swift
//  care-bears
//
//  Created by Samuel Echikson on 12/25/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit

class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)!
    }
    
    
}
