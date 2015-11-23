//
//  PieLayoutLayer.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation

public typealias LayoutDefinition = (parentGraph: Graph) -> (innerRadius:CGFloat,outerRadius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)

class PieLayoutLayer: CustomAnimLayer {
    
    var layoutDefiniton:LayoutDefinition?
    var parent: Graph?
    
    init(layoutDefiniton:LayoutDefinition, parent: Graph) {
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