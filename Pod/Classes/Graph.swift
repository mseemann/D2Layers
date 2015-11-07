//
//  Graph.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation
import UIKit

public class Graph {
    
    let layer: CALayer
    public var childs:[Graph] = []
    
    public init(layer:CALayer){
        self.layer = layer
    }
    
    internal func addChild(g:Graph) {
        g.layer.frame = self.layer.bounds
        self.layer.addSublayer(g.layer)
        childs.append(g)
    }
    
    public func circle(at at:CGPoint, r:CGFloat) -> CircleGraph {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalInRect: CGRectMake(at.x-r, at.y-r, 2*r, 2*r)).CGPath
        let g = CircleGraph(layer: circleLayer)
        addChild(g)
        return g
    }
    
    public func pieSlice() -> PieSlice {
        let slice = PieSliceLayer()
        let p = PieSlice(layer:slice)
        addChild(p)
        return p
    }
    
    public func group() -> Graph {
        let layer = CALayer()
        let g = Graph(layer: layer)
        addChild(g)
        return g;
    }
    
    public func get(index:Int) -> Graph {
        return childs[index]
    }
}


public class PieSlice: Graph {
    let pieSlice:PieSliceLayer
    
    init(layer: PieSliceLayer) {
        self.pieSlice = layer
        super.init(layer: layer)
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
}

public class CircleGraph: Graph {
    
    let shapelayer: CAShapeLayer
    
    init(layer: CAShapeLayer) {
        self.shapelayer = layer
        super.init(layer: layer)
    }
    
    public func fillColor(color:UIColor) -> CircleGraph {
        shapelayer.fillColor = color.CGColor
        return self
    }
}

