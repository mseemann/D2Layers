//
//  PieSliceLayer.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation

public class PieSliceLayer: CustomAnimPieLayer {
    
    private static let animProps = ["startAngle", "endAngle", "innerRadius", "outerRadius", "fillColor", "strokeColor", "strokeWidth"]
    
    public override init() {
        super.init()
        self.fillColor = UIColor.grayColor().CGColor
        self.strokeColor = UIColor.blackColor().CGColor
        self.strokeWidth = 1.0
//
//        self.shadowRadius = 10.0
//        self.shadowOffset = CGSize(width: 0, height: 0)
//        self.shadowColor = UIColor.grayColor().CGColor
//        self.masksToBounds = false
//        self.shadowOpacity = 1.0
        
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
            self.innerRadius = slice.innerRadius;
            self.outerRadius = slice.outerRadius;
            
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
        let center      = CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height/2)
        let radius      = Float(outerRadius)
        let iRadius     = Float(innerRadius)
        
        CGContextSetFillColorWithColor(ctx, fillColor)
        CGContextSetStrokeColorWithColor(ctx, strokeColor)
        CGContextSetLineWidth(ctx, CGFloat(strokeWidth))
        
        CGContextBeginPath(ctx)
        
        let p0 = CGPoint(x:CGFloat(Float(center.x) + iRadius * cosf(Float(startAngle))), y:CGFloat(Float(center.y) + iRadius * sinf(Float(startAngle))))
        CGContextMoveToPoint(ctx, p0.x, p0.y)
        
        let p1 = CGPoint(x:CGFloat(Float(center.x) + radius * cosf(Float(startAngle))), y:CGFloat(Float(center.y) + radius * sinf(Float(startAngle))))
        CGContextAddLineToPoint(ctx, p1.x, p1.y)
        
        let clockwise = self.startAngle > self.endAngle ? 1 : 0
        CGContextAddArc(ctx, center.x, center.y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), Int32(clockwise))
        
        let p3 = CGPoint(x:CGFloat(Float(center.x) + iRadius * cosf(Float(endAngle))), y:CGFloat(Float(center.y) + iRadius * sinf(Float(endAngle))))
        CGContextAddLineToPoint(ctx, p3.x, p3.y)
        
        CGContextAddArc(ctx, center.x, center.y, CGFloat(iRadius), CGFloat(endAngle), CGFloat(startAngle), Int32(clockwise == 0 ? 1: 0))

        CGContextClosePath(ctx)
        
        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
    }
    
    func createAnimationForKey(key: String) -> CAAnimation? {
        let anim = CABasicAnimation(keyPath: key)
        anim.fromValue = self.presentationLayer()?.valueForKey(key)
        if anim.fromValue == nil {
            anim.fromValue = self.valueForKey(key)
        }
        
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        anim.duration = 0.3
        return anim
    }
    
    
    override public func layoutSublayers() {
        self.frame = (superlayer?.bounds)!
        super.layoutSublayers()
    }

}
