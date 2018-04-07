//
//  BViewController.swift
//  viewTransition
//
//  Created by 정기웅 on 2018. 4. 5..
//  Copyright © 2018년 정기웅. All rights reserved.
//

import UIKit

class BViewController: UIViewController {

    @IBOutlet weak var top: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("b load")
        if let modalTransition = self.transitioningDelegate as? SampleAnimaionTransitioning {
            modalTransition.addGestureRecognizersToView(self.view, naviView: self.top)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
