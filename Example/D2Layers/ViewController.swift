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
        
//        self.layer.shadowRadius = 10.0
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowColor = UIColor.grayColor().CGColor
//        self.layer.masksToBounds = false
//        self.layer.shadowOpacity = 1.0
    }
    
    override func layoutSubviews() {
        root?.needsLayout()
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var vPieChart: D2LayerView!
    
    var switcher = false
    
    var pieLayout:PieLayout?
    
    var normalizedValues : [Double] = []
    
    let colorScale = OrdinalScale<Int, UIColor>.category20c()
    
    var count = 5
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let root = vPieChart.root {
            let circle = root.circle{
                (parentGraph: Graph) in
                
                    let parentSize = parentGraph.layer.bounds.size
                
                    let at = CGPoint(x: parentSize.width/2, y: parentSize.height/2)
                    let r = min(parentSize.width, parentSize.height)/CGFloat(2.0)
                
                    return (at:at, r:r)
                
                }.fillColor(UIColor.grayColor().brighter())
            
            
            
            pieLayout = circle.pieLayout{
                (parentGraph: Graph) in
                
                    let outerRadius = (min(parentGraph.layer.bounds.width, parentGraph.layer.bounds.height)/2) - 1
                
                    return (innerRadius:outerRadius*0.75, outerRadius:outerRadius, startAngle:CGFloat(0), endAngle:CGFloat(2*M_PI))
                }
                .data(updateSlices()){
                    (pieSlice:PieSlice, normalizedValue:Double, index:Int) in
                    pieSlice.fillColor(self.colorScale.scale(index).brighter())
                    pieSlice.strokeColor(UIColor(white: 0.25, alpha: 1.0))
                    pieSlice.strokeWidth(0.25)
                    
            }

        }
    }

    
    @IBAction func doit(sender: AnyObject) {
        
        if let pieLayout = pieLayout {

            pieLayout.data(updateSlices())
            
            let scale = (1.0 - CGFloat(arc4random_uniform(128))/255.0)
            
            let selection = pieLayout.selectAll(PieSlice.self)
            
            for g in selection.all() {
                g.innerRadius(scale * g.outerRadius())
            }
        
        }
    }
    

    internal func updateSlices() -> [Double]{
        var sliceValues:[Double] = []
        for(var i=0; i < count; i++) {
            sliceValues.append(Double(arc4random_uniform(100)))
        }
        return sliceValues
    }
}

