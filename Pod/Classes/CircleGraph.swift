//
//  CircleGraph.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation


public class CircleGraph: Graph {
    
    let circleLayer: CircleLayer
    
    init(layer: CircleLayer, parent: Graph) {
        self.circleLayer = layer
        super.init(layer: layer, parent:parent)
    }
    
    public func fillColor(color:UIColor) -> CircleGraph {
        circleLayer.fillColor = color.CGColor
        return self
    }
    
}