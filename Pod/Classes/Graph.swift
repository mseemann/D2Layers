//
//  Graph.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//


import Foundation
import UIKit



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
        self.layer.contentsScale = UIScreen.mainScreen().scale;
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
    
    public func pieLayout(layoutDefiniton:LayoutDefinition) -> PieLayout {
        let pieLayout = PieLayout(parent: self, layoutDefiniton: layoutDefiniton)
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
        The parameter typeToSelect is generally not really needed - but it looks more natural if you specify what you want in the function parameter and not as the result type of the funciton :)
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



