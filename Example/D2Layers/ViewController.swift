//
//  ViewController.swift
//  TestGraphics
//
//  Created by Michael Seemann on 04.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import UIKit
import D2Layers

class D2LayerView: UIView {
    
    var root: Graph?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rootInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rootInit()
    }
    
    func rootInit() {
       root = Graph(layer: self.layer, parent: nil)
    }
    
    override func layoutSubviews() {
        root?.needsLayout()
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var vPieChart: D2LayerView!
    
    var switcher = false
    
    var pieGroup:Graph?
    
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
                .fillColor(colorScale.scale(index).brighter(switcher ? 1.5 : -1.5))
            
            startAngle += angle
        }
        
        switcher = !switcher
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        vPieChart.root?.circle{
            (parentGraph: Graph) in
            
            let at = CGPoint(x: parentGraph.layer.bounds.size.width/2, y: parentGraph.layer.bounds.size.height/2)
            let r = min(parentGraph.layer.bounds.width, parentGraph.layer.bounds.size.height)/CGFloat(2.0)
            return (at:at, r:r)
            
        }.fillColor(UIColor(white: 0.85, alpha: 1.0))
        
        pieGroup = vPieChart.root?.group()
        
        // this way? no - with callback and parentlayout pieGroup = vPieChart.root?.createPieLayout(innerRadius:0, outerRadius:20, fromAngle:0, toAngle:2π)
        
        //pieGroup.data(sliceValues).onPieSlice(calbback zur Berechnung?)
        
        sliceValues = [Int(arc4random_uniform(100)), Int(arc4random_uniform(100)), Int(arc4random_uniform(100)),Int(arc4random_uniform(100)),Int(arc4random_uniform(100))]
    }

    
    @IBAction func doit(sender: AnyObject) {
        sliceValues = [Int(arc4random_uniform(100)), Int(arc4random_uniform(100)), Int(arc4random_uniform(100)),Int(arc4random_uniform(100)),Int(arc4random_uniform(100))]
    }

}

