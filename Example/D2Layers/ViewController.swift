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
        root = Graph(layer: self.layer, parent: nil, type:.ROOT)
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
    
    let colorScale = OrdinalScale<UIColor>.category10()
    
    internal var sliceValues: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliceValues = [Int(arc4random_uniform(100)), Int(arc4random_uniform(100)), Int(arc4random_uniform(100)),Int(arc4random_uniform(100)),Int(arc4random_uniform(100))]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        vPieChart.root?.circle{
            (parentGraph: Graph) in
            
                let at = CGPoint(x: parentGraph.layer.bounds.size.width/2, y: parentGraph.layer.bounds.size.height/2)
                let r = min(parentGraph.layer.bounds.width, parentGraph.layer.bounds.size.height)/CGFloat(2.0)
            
            return (at:at, r:r)
            
            }.fillColor(UIColor(white: 0.85, alpha: 0.0))
        
        
        
        pieLayout = vPieChart.root?.pieLayout{
            (parentGraph: Graph) in
            
                let outerRadius = min(parentGraph.layer.bounds.width, parentGraph.layer.bounds.height)/2.1
            
            return (innerRadius:outerRadius*0.75, outerRadius:outerRadius, startAngle:CGFloat(0), endAngle:CGFloat(2*M_PI))
            }
            .data(sliceValues){
                (pieSlice:PieSlice, normalizedValue:Double, index:Int) in
                pieSlice.fillColor(self.colorScale.scale(index).brighter())
                pieSlice.strokeColor(UIColor(white: 0.25, alpha: 1.0))
                pieSlice.strokeWidth(0.25)
                
        }
       
    }

    
    @IBAction func doit(sender: AnyObject) {
        sliceValues = []
        
        for(var i=0; i < Int(arc4random_uniform(10)+1) ; i++) {
            sliceValues.append(Int(arc4random_uniform(100)))
        }

        pieLayout?.data(sliceValues)
        
        let selection = pieLayout?.selectAll(.PIE_SLICE)
        for g in (selection!.all() as? [PieSlice])! {
            g.innerRadius((1.0 - CGFloat(arc4random_uniform(128))/255.0) * g.outerRadius())
        }
        
    }

}

