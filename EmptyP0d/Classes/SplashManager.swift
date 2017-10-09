//
//  SplashManager.swift
//  Pods
//
//  Created by Giuseppe Valenti on 10/7/17.
//
//

import Foundation

public class SplashManager {
    static let sharedInstance = SplashManager()
    
    // MARK: - Properties
    var fromView: UIImageView?
    let transitionController: TransitionViewController?
    let navigationController: UINavigationController?
    let originalFirstVC: UIViewController?
    
    // Initialization
    
    private init() { //This prevents others from using the default '()' initializer for this class.
        self.fromView = UIImageView()
        self.transitionController = TransitionViewController()
        self.navigationController = UINavigationController()
        //        let objects = Bundle.main.loadNibNamed("LaunchScreen", owner: self, options: nil)
        //        self.fromView = objects?[0] as? UIView
        //
        //        NSLog("fromView %@", self.fromView.debugDescription)
        self.originalFirstVC = UIViewController()
    }
    
    public init(fromViewWithTag: Int, appDelegate: UIApplicationDelegate) {
        NSLog("Initialized")
        
      
        
        let objects = Bundle.main.loadNibNamed("LaunchScreen", owner: nil, options: nil)
        let originalSplash = objects?[0] as? UIView
        let originalLogo = originalSplash?.viewWithTag(99) as? UIImageView
        self.fromView = UIImageView(image: originalLogo?.image)
        self.navigationController = UINavigationController()
        self.transitionController = TransitionViewController()
        self.transitionController?.logo = fromView
        self.transitionController?.bkgColor = originalSplash?.backgroundColor
        
        let originalConstraints = originalSplash?.constraints
        //        print("original constraints\(String(describing: originalConstraints))")
        
        
        //        let originalFrame = self.fromView?.center
        //        let xConstraint = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        //        let yConstraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterY, multiplier: 1, constant: 0)
        //        fromView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        //        NSLog("fromView %@", self.fromView.debugDescription)
        
        self.originalFirstVC = appDelegate.window!?.rootViewController
        var newConstraints = [NSLayoutConstraint]()
        
        for constraint in originalConstraints! {
            if constraint.firstItem === originalLogo && constraint.secondItem === originalSplash {
                
                let newConstr = (NSLayoutConstraint(item: fromView!, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: transitionController?.view, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
                
                newConstr.identifier = (constraint.firstAttribute == NSLayoutAttribute.centerY) ? "Vertical" : "Horizontal"
                newConstraints.append(
                    newConstr
                )
            }
        }
        
        
        
        self.transitionController?.constraints = newConstraints

        self.originalFirstVC?.addChildViewController(transitionController!)

        self.originalFirstVC?.view.addSubview((transitionController?.view)!)
        
        self.transitionController?.didMove(toParentViewController: self.originalFirstVC)
        
        
        
    }
    
    static func copyConstraints(fromView sourceView: UIView, toView destView: UIView) {
        guard let sourceViewSuperview = sourceView.superview, let destViewSuperview = destView.superview else {
            return
        }
        for constraint in sourceViewSuperview.constraints {
            if constraint.firstItem as? UIView == sourceView {
                sourceViewSuperview.addConstraint(NSLayoutConstraint(item: destView, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
            } else if constraint.secondItem as? UIView == sourceView {
                sourceViewSuperview.addConstraint(NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: destView, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
            }
        }
    }
}
