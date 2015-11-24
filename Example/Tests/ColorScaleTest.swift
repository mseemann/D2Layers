//
//  ColorScaleTest.swift
//  D2Layers
//
//  Created by Michael Seemann on 23.11.15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import D2Layers

class ColorCatgeorySpec: QuickSpec {
    
    override func spec() {
        describe("color catgegory test") {
            
            
            var scale:OrdinalScale<Int, UIColor>?
            var colors:[UIColor]?
            var n = 0
            
            beforeEach {
                scale = OrdinalScale<Int, UIColor>.category10()
                colors = scale!.range()
                n = 10
            }
            
            it("is should have a specific count of range values") {
                expect(colors!.count) == n
            }
            
            it("is an ordinal scale"){
                expect(scale!.scale(1)) == colors![0]
                expect(scale!.scale(2)) == colors![1]
                expect(scale!.scale(1)) == colors![0]
            }

            it("should work like a circle structure"){
                for var index = 0; index < n; ++index {
                    scale!.scale(index)
                }
                
                for var index = 0; index < n; ++index {
                    expect(scale!.scale(index + n)) == scale!.scale(index)
                }
            }
            
            it("shoudl have isolated instances"){
                let a = OrdinalScale<Int, UIColor>.category10()
                let colors = a.range()
                let b = OrdinalScale<Int, UIColor>.category10()
                
                expect(a.scale(1)) == colors[0]
                expect(b.scale(2)) == colors[0]
                expect(b.scale(1)) == colors[1]
                expect(a.scale(1)) == colors[0]
            }
            
            it("should have distinct range values") {
                let colors = scale!.range()
                let colorSet = Set(colors)
                expect(colorSet.count) == colors.count
            }
            
        }
    }
}
