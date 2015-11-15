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
    
    var layoutDefiniton:((parentGraph: Graph) -> (at:CGPoint, r:CGFloat))?
    var parent: Graph?
    
    init(layoutDefiniton:(parentGraph: Graph) -> (at:CGPoint, r:CGFloat), parent: Graph) {
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
        CGContextClosePath(ctx)

        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
    }
}

class PieLayoutLayer: CustomAnimLayer {
    
    var layoutDefiniton:((parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat))?
    var parent: Graph?
    
    init(layoutDefiniton:(parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat), parent: Graph) {
        self.layoutDefiniton = layoutDefiniton
        self.parent = parent
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let g = CircleGraph(layer: circleLayer, parent: self)
        addChild(g)
        g.needsLayout()
        return g
    }
    
    public func pieLayout(layoutDefiniton:(parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)) -> PieLayout {
        let layer = PieLayoutLayer(layoutDefiniton: layoutDefiniton, parent:self)
        let pieLayout = PieLayout(layer: layer, parent: self, layoutDefiniton: layoutDefiniton)
        addChild(pieLayout)
        pieLayout.needsLayout()
        return pieLayout
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
        // do not call this on the root layer because this is 
        // done by the view that contains the root layer
        if(parent != nil){
            layer.setNeedsLayout()
            layer.setNeedsDisplay()
        }
        
        for child in childs {
            child.needsLayout()
        }
    }
}

public class PieLayout: Graph {
    
    var normalizedValues: [Double]?
    
    init(layer: PieLayoutLayer, parent: Graph, layoutDefiniton:(parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)) {
        super.init(layer: layer, parent:parent)
    }
    
    public func data(values: [NSNumber], pieSliceCallback: (pieSlice:PieSlice, normalizedValue:Double, index:Int) -> Void) -> PieLayout {
        normalizedValues = calculateNormalizedValues(values.map{Double($0)});
        
        var startAngle:CGFloat = 0.0
        
        for (index, n) in normalizedValues!.enumerate() {
            let angle:CGFloat = CGFloat(n * 2 * M_PI)

            let slice = parent!.pieSlice()

            slice
                .startAngle(startAngle)
                .endAngle(startAngle + angle)

            pieSliceCallback(pieSlice: slice, normalizedValue: n, index: index);
            
            startAngle += angle
        }
        
        return self
    }
    
    public func data(values: [NSNumber]) -> PieLayout {
        normalizedValues = calculateNormalizedValues(values.map{Double($0)});
        
        // update layers
        
        return self
    }
    
    internal func calculateNormalizedValues (values: [Double]) -> [Double]{
        let total = Double(values.reduce(0, combine: +))
        return values.map{Double($0)/total}
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
    
    init(layer: CircleLayer, parent: Graph) {
        self.shapelayer = layer
        super.init(layer: layer, parent:parent)
    }
    
    public func fillColor(color:UIColor) -> CircleGraph {
        shapelayer.fillColor = color.CGColor
        return self
    }

}

