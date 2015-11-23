//
//  OrdinalScale.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation
import UIKit

public class OrdinalScale<T> {
    
    private var r:[T] = []
    
    public func range() -> [T] {
        return r
    }
    
    public func range(range: [T]) -> OrdinalScale<T> {
        self.r = range
        return self
    }
    
    public func scale(i:Int) -> T {
        return r[i % r.count]
    }
}

public extension OrdinalScale {

    internal static func toUIColorScale(colors:[UInt32]) -> OrdinalScale<UIColor> {
        return OrdinalScale<UIColor>().range(colors.map{UIColor(rgb: $0)});
    }
    
    public static func category10() -> OrdinalScale<UIColor> {
        return toUIColorScale(Colors.category10)
    }
    
    static func category20() -> OrdinalScale<UIColor> {
        return toUIColorScale(Colors.category20)
    }
    
    static func category20b() -> OrdinalScale<UIColor> {
        return toUIColorScale(Colors.category20b)
    }
    
    static func category20c() -> OrdinalScale<UIColor> {
        return toUIColorScale(Colors.category20c)
    }
}
