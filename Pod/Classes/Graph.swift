//
//  Graph.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//


import Foundation
import UIKit

class GraphLayer: CALayer {
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.frame = (superlayer?.bounds)!
    }
    
}

class CircleLayer: CustomAnimLayer {
    
    var layoutDefiniton:((parentGraph: Graph) -> (at:CGPoint,r:CGFloat))?
    var parent: Graph?
    
    init(layoutDefiniton:(parentGraph: Graph) -> (at:CGPoint,r:CGFloat), parent: Graph) {
        self.layoutDefiniton = layoutDefiniton
        self.parent = parent
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: AnyObject) {
        super.init(layer:layer)
        if let slice = layer as? CircleLayer {
            self.parent = slice.parent
            self.layoutDefiniton = slice.layoutDefiniton
            self.fillColor = slice.fillColor;
            self.strokeColor = slice.strokeColor;
            self.strokeWidth = slice.strokeWidth;
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.frame = (superlayer?.bounds)!
    }
    
    override func drawInContext(ctx: CGContext) {
        super.drawInContext(ctx)

        let def =  layoutDefiniton!(parentGraph: parent!)
        let path = UIBezierPath(ovalInRect: CGRectMake(def.at.x-def.r, def.at.y-def.r, 2*def.r, 2*def.r))

        
        CGContextSetFillColorWithColor(ctx, fillColor)
        CGContextSetStrokeColorWithColor(ctx, strokeColor)
        CGContextSetLineWidth(ctx, CGFloat(strokeWidth))
        
        CGContextBeginPath(ctx)
        CGContextAddPath(ctx, path.CGPath)
        CGContextEndPage(ctx)

        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
    }
}

public class Graph {
    
    public let layer: CALayer
    public let parent: Graph?
    public var childs:[Graph] = []
    
    public init(layer:CALayer, parent: Graph?){
        self.layer = layer
        self.parent = parent
    }
    
    internal func addChild(g:Graph) {
        g.layer.frame = self.layer.bounds
        self.layer.addSublayer(g.layer)
        childs.append(g)
    }
    
    public func circle(layoutDefiniton:(parentGraph: Graph) -> (at:CGPoint,r:CGFloat)) -> CircleGraph {
        let circleLayer = CircleLayer(layoutDefiniton: layoutDefiniton, parent:self)
        let g = CircleGraph(layer: circleLayer, parent: self, layoutDefiniton: layoutDefiniton)
        addChild(g)
        g.needsLayout()
        return g
    }
    
    public func pieSlice() -> PieSlice {
        let slice = PieSliceLayer()
        let p = PieSlice(layer:slice, parent: self)
        addChild(p)
        return p
    }
    
    public func group() -> Graph {
        let layer = GraphLayer()
        let g = Graph(layer: layer, parent: self)
        addChild(g)
        return g;
    }
    
    public func get(index:Int) -> Graph {
        return childs[index]
    }
    
    public func needsLayout() {
        layer.setNeedsLayout()
        layer.setNeedsDisplay()
        for child in childs {
            child.needsLayout()
        }
    }
}


public class PieSlice: Graph {
    let pieSlice:PieSliceLayer
    
    init(layer: PieSliceLayer, parent: Graph) {
        self.pieSlice = layer
        super.init(layer: layer, parent:parent)
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
    
    let shapelayer: CircleLayer
    
    init(layer: CircleLayer, parent: Graph, layoutDefiniton:(parentGraph: Graph) -> (at:CGPoint,r:CGFloat)) {
        self.shapelayer = layer
        super.init(layer: layer, parent:parent)
    }
    
    public func fillColor(color:UIColor) -> CircleGraph {
        shapelayer.fillColor = color.CGColor
        return self
    }

}

