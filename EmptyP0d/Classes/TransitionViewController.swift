//
//  TransitionViewController.swift
//  Pods
//
//  Created by Giuseppe Valenti on 10/8/17.
//
//

import UIKit

class TransitionViewController: UIViewController {
    
    var constraints = [NSLayoutConstraint]()
    var logo : UIImageView? = nil
    var bkgColor : UIColor? = nil
    var bkgImg : UIView? = nil
    var parentVC : UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red
        self.view.addSubview(logo!)
        logo?.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = self.bkgColor;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addConstraints(constraints);
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.bkgImg = self.parent?.view.snapshotView(afterScreenUpdates: true)
        setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 1.50, delay: 0.2, options: [.curveEaseInOut], animations: {
            // change constraints inside animation block
            self.updateConstraints()
            
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: UIApplication.shared.statusBarFrame.height + 44)
            
            // force layout inside animation block
            self.view.layoutIfNeeded()
        }, completion: { (flag) in
            UIView .animate(withDuration: 0.3, animations: {
                self.logo?.alpha = 0
                self.logo?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion : { (flag) in
                print("finished \(flag)")
//                self.willMove(toParentViewController: nil)
//                self.view.removeFromSuperview()
//                self.removeFromParentViewController()
//                self.logo?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    
    }
    
    func updateConstraints() {
        for constr in self.constraints {
            print("constraint \n\(constr)")
            if constr.identifier == "Vertical" {
                constr.constant = ((UIApplication.shared.statusBarFrame.height + 44) * constr.multiplier)
            }else{
                //constr.constant = 42 - 50;
            }
        }
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
