//
//  OrdinalScale.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation
import UIKit

public class OrdinalScale<Domain:Hashable, Range> {
    
    private var r:[Range] = []
    private var d:[Domain] = []
    private var idx:[Domain:Int] = [:]
    
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
    
    public func scale(i:Domain) -> Range {
        if (idx[i] == nil) {
            d.append(i)
            idx[i] = d.count
        }

        let index = idx[i]! - 1 

        return r[index % r.count]
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
