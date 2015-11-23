//
//  PieLayout.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation

public class PieLayout: Graph {
    
    var layoutDefiniton: LayoutDefinition?
    var normalizedValues: [Double]?
    var pieSliceCallback: ((pieSlice:PieSlice, normalizedValue:Double, index:Int) -> Void)?
    
    init(parent: Graph, layoutDefiniton:LayoutDefinition) {
        let layer = PieLayoutLayer(layoutDefiniton: layoutDefiniton, parent:parent)
        self.layoutDefiniton = layoutDefiniton
        super.init(layer: layer, parent:parent)
    }
    
    public func pieSlice() -> PieSlice {
        let p = PieSlice(parent: self)
        addChild(p)
        return p
    }
    
    func calculateSlices() {
        if let normalizedValues = normalizedValues {
            
            let layoutDef = layoutDefiniton!(parentGraph: parent!)
            
            let overAllStartAngle   = layoutDef.startAngle
            let overAllEndAngle     = layoutDef.endAngle
            let range = overAllEndAngle - overAllStartAngle
            
            var startAngle:CGFloat = overAllStartAngle
            
            let slices = self.selectAll(PieSlice.self)
            
            for (index, n) in normalizedValues.enumerate() {
                let angle:CGFloat = CGFloat(n * 2 * M_PI)
                
                let scaleAngle = range/CGFloat(2 * M_PI) * angle
                
                let endAngle = startAngle + scaleAngle
                
                // add or update
                let slice = slices.hasIndex(index) ? slices.get(index) : self.pieSlice()
                
                slice
                    .startAngle(startAngle)
                    .endAngle(endAngle)
                    .innerRadius(layoutDef.innerRadius)
                    .outerRadius(layoutDef.outerRadius)
                
                if let pieSliceCallback = pieSliceCallback {
                    pieSliceCallback(pieSlice: slice, normalizedValue: n, index: index);
                }
                
                startAngle = endAngle
            }
            
            // remove unused pieslices
            let removedSlices:[Graph] = slices.getUnAskedGraphs()
            for slice in removedSlices {
                slice.removeFromParent()
            }
            
        }
    }
    
    public func data(values: [Double], pieSliceCallback: (pieSlice:PieSlice, normalizedValue:Double, index:Int) -> Void) -> PieLayout {
        self.normalizedValues = calculateNormalizedValues(values);
        self.pieSliceCallback = pieSliceCallback
        calculateSlices()
        return self
    }
    
    public func data(values: [Double]) -> PieLayout {
        normalizedValues = calculateNormalizedValues(values);
        calculateSlices()
        return self
    }
    
    internal func calculateNormalizedValues (values: [Double]) -> [Double]{
        let total = Double(values.reduce(0, combine: +))
        return values.map{Double($0)/total}
    }
    
    public override func needsLayout() {
        calculateSlices()
        super.needsLayout()
    }
}