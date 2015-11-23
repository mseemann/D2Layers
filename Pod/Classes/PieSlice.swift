//
//  PieSlice.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation

public class PieSlice: Graph {
    let pieSlice:PieSliceLayer
    
    init(parent: Graph) {
        self.pieSlice = PieSliceLayer()
        super.init(layer: pieSlice, parent:parent)
    }
    
    public func strokeColor(color:UIColor) -> PieSlice {
        pieSlice.strokeColor = color.CGColor
        return self
    }
    
    public func strokeWidth(width: CGFloat) -> PieSlice {
        pieSlice.strokeWidth = width
        return self
    }
    
    public func fillColor(color:UIColor) -> PieSlice {
        pieSlice.fillColor = color.CGColor
        return self
    }
    
    public func startAngle(angle:CGFloat) -> PieSlice {
        pieSlice.startAngle = angle
        return self
    }
    
    public func endAngle(angle:CGFloat) -> PieSlice {
        pieSlice.endAngle = angle
        return self
    }
    
    public func innerRadius(r:CGFloat) -> PieSlice {
        pieSlice.innerRadius = r
        return self
    }
    
    public func outerRadius(r:CGFloat) -> PieSlice {
        pieSlice.outerRadius = r
        return self
    }
    
    public func outerRadius() -> CGFloat {
        return pieSlice.outerRadius
    }
}