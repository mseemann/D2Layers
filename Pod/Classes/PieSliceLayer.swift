//
//  PieSliceLayer.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation

public class PieSliceLayer: CustomAnimPieLayer {
    
    private static let animProps = ["startAngle", "endAngle", "fillColor", "strokeColor", "strokeWidth"]
    
    public override init() {
        super.init()
        self.fillColor = UIColor.grayColor().CGColor
        self.strokeColor = UIColor.blackColor().CGColor
        self.strokeWidth = 1.0
        self.setNeedsDisplay()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(layer: AnyObject) {
        super.init(layer:layer)
        if let slice = layer as? PieSliceLayer {
            self.startAngle = slice.startAngle;
            self.endAngle = slice.endAngle;
            self.fillColor = slice.fillColor;
            
            self.strokeColor = slice.strokeColor;
            self.strokeWidth = slice.strokeWidth;
        }
    }
    
    override static public func needsDisplayForKey(key: String) -> Bool{
        if animProps.contains(key) {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    
    override public func actionForKey(event: String) -> CAAction? {
        if PieSliceLayer.animProps.contains(event){
            return createAnimationForKey(event)
        }
        return super.actionForKey(event)
    }
    
    override public func drawInContext(ctx: CGContext) {
        let center = CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height/2)
        let radius:Float = min(Float(center.x), Float(center.y))
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, center.x, center.y)
        
        let p1 = CGPoint(x:CGFloat(Float(center.x) + radius * cosf(Float(startAngle))), y:CGFloat(Float(center.y) + radius * sinf(Float(startAngle))))
        CGContextAddLineToPoint(ctx, p1.x, p1.y)
        
        let clockwise = self.startAngle > self.endAngle ? 1 : 0
        CGContextAddArc(ctx, center.x, center.y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), Int32(clockwise))
        
        CGContextClosePath(ctx)
        
        CGContextSetFillColorWithColor(ctx, fillColor)
        CGContextSetStrokeColorWithColor(ctx, strokeColor)
        CGContextSetLineWidth(ctx, CGFloat(strokeWidth))
        
        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
    }
    
    func createAnimationForKey(key: String) -> CAAnimation? {
        let anim = CABasicAnimation(keyPath: key)
        anim.fromValue = self.presentationLayer()?.valueForKey(key)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.duration = 0.0
        return anim
    }
    
    
    override public func layoutSublayers() {
        super.layoutSublayers()
        self.frame = (superlayer?.bounds)!
    }

}
