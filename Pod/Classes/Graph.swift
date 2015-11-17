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
    
    override init(layer: AnyObject) {
        super.init(layer:layer)
        if let slice = layer as? PieLayoutLayer {
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
}


// TODO save Key and Data at the graph or at the layer?

public class Graph {
    
    public let layer: CALayer
    public let parent: Graph?
    public var childs:[Graph] = []
    
    public var backgroundColor:CGColorRef? {
        get {
            return layer.backgroundColor
        }
        set {
            layer.backgroundColor = newValue
        }
    }
    
    public init(layer:CALayer, parent: Graph?){
        self.layer = layer
        self.parent = parent
    }
    
    internal func addChild(g:Graph) {
        g.layer.frame = self.layer.bounds
        self.layer.addSublayer(g.layer)
        childs.append(g)
    }
    
    func removeFromParent(){
        parent!.removeChild(self)
    }
    
    func removeChild(child: Graph){
        child.layer.removeFromSuperlayer()
        childs.removeAtIndex(childs.indexOf{$0 === child}!)
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
    
    /**
        typeToSelect is generally not really needed - but it looks more natural if you specify what you want in the function parameter and not as the result type of the funciton :)
    */
    public func selectAll<T:Graph>(typeToSelect:T.Type, deep:Bool = false) -> D2LayerSelection<T> {
        let selection = D2LayerSelection<T>()
        
        for child in childs {
            if child is T {
                selection.add(child as! T)
            }
            if deep {
                let subSelection = child.selectAll(typeToSelect, deep:deep)
                selection.add(subSelection)
            }
        }
        
        return selection
        
    }
}

public class D2LayerSelection<T> {
    
    var selected:[T] = []
    var askIndexes = Set<Int>()
    
    func add(graph:T){
        selected.append(graph)
    }
    
    func add(selection: D2LayerSelection<T>) {
        selected.appendContentsOf(selection.all())
    }
    
    
    func hasIndex(i:Int) -> Bool {
        askIndexes.insert(i)
        return i < selected.count
    }
    
    func get(i:Int) -> T {
        return selected[i]
    }
    
    func getUnAskedGraphs() -> [T] {
        var result: [T] = []
        
        for (index, g) in selected.enumerate() {
            if !askIndexes.contains(index){
                result.append(g)
            }
        }
        
        return result
    }
    
    public func all() -> [T]{
        return selected
    }
}


public class PieLayout: Graph {
    
    var normalizedValues: [Double]?
    var pieSliceCallback: ((pieSlice:PieSlice, normalizedValue:Double, index:Int) -> Void)?
    var layoutDefiniton: ((parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat))?
    
    init(layer: PieLayoutLayer, parent: Graph, layoutDefiniton:(parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)) {
        self.layoutDefiniton = layoutDefiniton
        super.init(layer: layer, parent:parent)
    }
    
    public func pieSlice() -> PieSlice {
        let slice = PieSliceLayer()
        let p = PieSlice(layer:slice, parent: self)
        addChild(p)
        return p
    }
    
    func calculateSlices() {
        if let normalizedValues = normalizedValues {
        
            let layoutDef = layoutDefiniton!(parentGraph: parent!)
            
            var startAngle:CGFloat = 0.0
            
            let slices = self.selectAll(PieSlice.self)
            
            for (index, n) in normalizedValues.enumerate() {
                let angle:CGFloat = CGFloat(n * 2 * M_PI)
                
                let endAngle = startAngle + angle
                
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
    
    public func data(values: [NSNumber], pieSliceCallback: (pieSlice:PieSlice, normalizedValue:Double, index:Int) -> Void) -> PieLayout {
        self.normalizedValues = calculateNormalizedValues(values.map{Double($0)});
        self.pieSliceCallback = pieSliceCallback
        calculateSlices()
        return self
    }
    
    public func data(values: [NSNumber]) -> PieLayout {
        normalizedValues = calculateNormalizedValues(values.map{Double($0)});
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

