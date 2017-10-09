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
    var navigationController: UINavigationController?
    var originalFirstVC: UIViewController?
    
    // Initialization
    
    private init() { //This prevents others from using the default '()' initializer for this class.
        self.fromView = UIImageView()
        self.transitionController = TransitionViewController()
        self.navigationController = nil
        //        let objects = Bundle.main.loadNibNamed("LaunchScreen", owner: self, options: nil)
        //        self.fromView = objects?[0] as? UIView
        //
        //        NSLog("fromView %@", self.fromView.debugDescription)
        self.originalFirstVC = nil
    }
    
    public init(fromViewWithTag: Int, appDelegate: UIApplicationDelegate) {
        NSLog("Initialized")
        
      
        
        let objects = Bundle.main.loadNibNamed("LaunchScreen", owner: nil, options: nil)
        let originalSplash = objects?[0] as? UIView
        let originalLogo = originalSplash?.viewWithTag(99) as? UIImageView
        self.fromView = UIImageView(image: originalLogo?.image)
//        self.navigationController = UINavigationController()
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
        
        if ((appDelegate.window!?.rootViewController)?.isKind(of: UINavigationController.self))! {
            print("NAVIGATION CONTROLLER")
            self.navigationController = (appDelegate.window!?.rootViewController as! UINavigationController)
        }else{
            print("UIVIEW CONTROLLER")
//            self.originalFirstVC = (appDelegate.window!?.rootViewController)
        }
        
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
        
        if (navigationController != nil) {
            navigationController?.topViewController?.addChildViewController(transitionController!)
            
            transitionController?.view.frame = (navigationController?.topViewController?.view.bounds)!
            
            navigationController?.topViewController?.view.addSubview((transitionController?.view)!)
            
            self.transitionController?.didMove(toParentViewController: navigationController?.topViewController)

            let transparentPixel = UIImage(named: "EmptyPixel")
            
            navigationController?.navigationBar.setBackgroundImage(transparentPixel, for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = transparentPixel
            navigationController?.navigationBar.backgroundColor = UIColor.clear
            navigationController?.navigationBar.isTranslucent = true
            
            
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            let deadlineTime = DispatchTime.now() + .seconds(5/2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                print("BEFORE post animation")
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                let newLogo = UIImageView(image: originalLogo?.image)
                newLogo.alpha = 0.5
                newLogo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.navigationController?.navigationBar.topItem?.titleView = newLogo
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [UIViewAnimationOptions.transitionCrossDissolve], animations: {
                    self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
                    self.navigationController?.navigationBar.shadowImage = nil
                    self.navigationController?.navigationBar.backgroundColor = originalSplash?.backgroundColor
                    self.navigationController?.navigationBar.isTranslucent = false
                    newLogo.alpha = 1
                    newLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (flag) in
                    print("POST Completed")
                    
                })
            }
            
        }else{
            self.originalFirstVC = (appDelegate.window!?.rootViewController)
            self.originalFirstVC?.addChildViewController(transitionController!)
            
            transitionController?.view.frame = (originalFirstVC?.view.bounds)!
            
            self.originalFirstVC?.view.addSubview((transitionController?.view)!)
            
            self.transitionController?.didMove(toParentViewController: self.originalFirstVC)
        }

        
    }
    
    public func finished(){
    
    }
    
}
