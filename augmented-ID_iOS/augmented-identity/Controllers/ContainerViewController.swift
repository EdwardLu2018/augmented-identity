//
//  ContainerViewController.swift
//  slideMenu
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let left = self.storyboard?.instantiateViewController(withIdentifier: "left") as! LeftViewController
        self.addChild(left)
        self.scrollView.addSubview(left.view)
        
        let middle = self.storyboard?.instantiateViewController(withIdentifier: "middle") as! MiddleViewController
        self.addChild(middle)
        self.scrollView.addSubview(middle.view)
        
        let right = self.storyboard?.instantiateViewController(withIdentifier: "right") as! RightViewController
        self.addChild(right)
        self.scrollView.addSubview(right.view)
        
        self.didMove(toParent: self)
        
        var middleFrame : CGRect = middle.view.frame
        middleFrame.origin.x = self.view.frame.width
        middle.view.frame = middleFrame
        
        var rightFrame : CGRect = right.view.frame
        rightFrame.origin.x = 2 * self.view.frame.width
        right.view.frame = rightFrame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentSize.width / 3, y: 0.0)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }
    
}
