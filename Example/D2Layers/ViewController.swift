//
//  ViewController.swift
//  TestGraphics
//
//  Created by Michael Seemann on 04.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import UIKit
import D2Layers


class ViewController: UIViewController {
    
    @IBOutlet weak var vPieChart: UIView!
    
    var switcher = false
    
    var pieGroup:Graph?
    var root:Graph?
    
    var normalizedValues : [Double] = []
    
    let colorScale = OrdinalScale<UIColor>.category10()
    
    internal var sliceValues: [Int] = [] {
        didSet {
            let total = Double(sliceValues.reduce(0, combine: +))
            
            normalizedValues = sliceValues.map{Double($0)/total}
            
            if pieGroup?.childs.count == 0 {
                initPieSlices()
            }
            drawPieSlices();
        }
    }
    
    func initPieSlices(){
        
        
        for (index, _) in normalizedValues.enumerate() {
            
            pieGroup?.pieSlice()
                .strokeColor(UIColor(white: 0.25, alpha: 1.0))
                .strokeWidth(0.5)
                .fillColor(colorScale.scale(index))
            
        }
    }
    
    func drawPieSlices() {
        if pieGroup?.childs.count == 0 {
            return
        }
        
        var startAngle:CGFloat = 0.0
        
        
        for (index, n) in normalizedValues.enumerate() {
            let angle:CGFloat = CGFloat(n * 2 * M_PI)
            
            (pieGroup!.get(index) as! PieSlice)
                .startAngle(startAngle)
                .endAngle(startAngle + angle)
                .fillColor(colorScale.scale(index).brighter(switcher ? 1.0 : -1.0))
            
            startAngle += angle
        }
        
        switcher = !switcher
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        root = Graph(layer: vPieChart.layer)
        
        root?.circle(at:CGPoint(x: vPieChart.frame.size.width/2, y: vPieChart.frame.size.height/2), r:vPieChart.frame.size.width/CGFloat(2.0))
            .fillColor(UIColor(white: 0.85, alpha: 1.0))
        
        pieGroup = root?.group()
        
        sliceValues = [Int(arc4random_uniform(100)), Int(arc4random_uniform(100)), Int(arc4random_uniform(100)),Int(arc4random_uniform(100)),Int(arc4random_uniform(100))]
    }
    
    @IBAction func doit(sender: AnyObject) {
        sliceValues = [Int(arc4random_uniform(100)), Int(arc4random_uniform(100)), Int(arc4random_uniform(100)),Int(arc4random_uniform(100)),Int(arc4random_uniform(100))]
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    }
}

