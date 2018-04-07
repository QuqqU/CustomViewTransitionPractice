//
//  AViewController.swift
//  viewTransition
//
//  Created by 정기웅 on 2018. 4. 5..
//  Copyright © 2018년 정기웅. All rights reserved.
//

import UIKit

class AViewController: UIViewController {

    let transitionManager = SampleAnimaionTransitioning()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self.transitionManager
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modal_segue" {
            print("prepare a")
            if let vc = segue.destination as? BViewController {
                vc.transitioningDelegate = self.transitionManager
                vc.modalPresentationStyle = .custom
            }
        }
    }
}



