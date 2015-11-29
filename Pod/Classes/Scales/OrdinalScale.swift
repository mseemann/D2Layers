//
//  OrdinalScale.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation
import UIKit

public enum OrdinalScaleError: ErrorType {
    case RangePointError(String)
}

enum OrdinalScaleRangeType {
    case RANGE
    case RANGE_POINTS
    case RANGE_ROUND_POINTS
}

public class OrdinalScale<Domain:Hashable, Range> {
    
    private var r:[Range] = []
    private var d:[Domain] = []
    private var idx:[Domain:Int] = [:]
    private var rangeType = OrdinalScaleRangeType.RANGE
    public var rangeBand:Double = 0
    
    public func range() -> [Range] {
        return r
    }
    
    public func range(range: [Range]) -> OrdinalScale<Domain, Range> {
        self.r = range
        return self
    }
    
    public func domain() -> [Domain]{
        return d
    }
    
    public func domain(d:[Domain]) -> OrdinalScale<Domain, Range> {
        self.d = []
        self.idx = [:]
        for dv in d {
            addDomainValue(dv)
        }
        
        return self
    }
    
    public func scale(dv:Domain) -> Range? {
        // only RANGE is autoexpandable
        if rangeType == .RANGE {
            addDomainValue(dv)
        }

        let index = (idx[dv] ?? 0) - 1
        if index == -1 || r.count == 0 {
            return nil
        }
        let rangeIndex = index % r.count
        return r[rangeIndex]
    }
    
    internal func addDomainValue(dv:Domain){
        if (idx[dv] == nil) {
            d.append(dv)
            idx[dv] = d.count
        }
    }
    
    internal func steps(start:Double, step:Double) -> [Double] {
        var result:[Double] = []
        
        for var index = 0.0; index < Double(d.count); ++index {
            let rangeValue = start + step * index
            result.append(rangeValue)
        }
        print(start, step, result)
        return result
    }
    
    // only usable if Range is a Double
    public func rangePoints(var start start:Double, stop:Double, padding:Double = 0) throws -> OrdinalScale<Domain, Range> {
        rangeType = .RANGE_POINTS

        var step = 0.0
        if d.count < 2 {
            start = (start + stop) / 2
        } else {
            step = (stop - start) / (Double(d.count) - 1 + padding)
        }
        r = steps(start + step * padding / 2.0, step: step).map{print($0); return $0 as! Range}
        
        return self
    }
    
    // only usable if Range is a Double - even so the points are at a value with no fractions
    public func rangeRoundPoints(var start start:Double, var stop:Double, padding:Double = 0) throws -> OrdinalScale<Domain, Range> {
        rangeType = .RANGE_ROUND_POINTS
        
        var inverse = false
        
        if start > stop {
            let tmp = start
            start = stop
            stop = tmp
            inverse = true
        }

        var step = 0.0
        if d.count < 2 {
            start = round((start + stop) / 2)
            stop = start
        } else {
            step = floor((stop - start) / (Double(d.count) - 1.0 + padding))
        }
        
        start = start + round(step * padding / 2.0 + (stop - start - (Double(d.count) - 1 + padding) * step) / 2.0)
        
        let theSteps = steps(start, step:step).map{$0 as! Range}

        r = inverse ? theSteps.reverse() : theSteps
        
        return self
    }
}

public extension OrdinalScale {

    internal static func toUIColorScale(colors:[UInt32]) -> OrdinalScale<Int, UIColor> {
        return OrdinalScale<Int,UIColor>().range(colors.map{UIColor(rgb: $0)});
    }
    
    public static func category10() -> OrdinalScale<Int, UIColor> {
        return toUIColorScale(Colors.category10)
    }
    
    static func category20() -> OrdinalScale<Int, UIColor> {
        return toUIColorScale(Colors.category20)
    }
    
    static func category20b() -> OrdinalScale<Int, UIColor> {
        return toUIColorScale(Colors.category20b)
    }
    
    static func category20c() -> OrdinalScale<Int, UIColor> {
        return toUIColorScale(Colors.category20c)
    }
}
