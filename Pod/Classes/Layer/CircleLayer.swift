//
//  CircleLayer.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation

class CircleLayer: CustomAnimLayer {
    
    var layoutDefiniton:((parentGraph: Graph) -> (at:CGPoint, r:CGFloat))?
    var parent: Graph?
    
    init(layoutDefiniton:(parentGraph: Graph) -> (at:CGPoint, r:CGFloat), parent: Graph) {
        self.layoutDefiniton = layoutDefiniton
        self.parent = parent
        super.init()
        //        self.shadowRadius = 10.0
        //        self.shadowOffset = CGSize(width: 0, height: 0)
        //        self.shadowColor = UIColor.grayColor().CGColor
        //        self.shadowOpacity = 1.0
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
        
        
        CGContextSetFillColorWithColor(ctx, fillColor)
        CGContextSetStrokeColorWithColor(ctx, strokeColor)
        CGContextSetLineWidth(ctx, CGFloat(strokeWidth))
        
        CGContextBeginPath(ctx)
        CGContextAddEllipseInRect(ctx, CGRectMake(def.at.x-def.r, def.at.y-def.r, 2*def.r, 2*def.r));
        CGContextClosePath(ctx)
        
        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
    }
}