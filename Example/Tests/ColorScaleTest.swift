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
 
            it("is an ordinal scale") {
                let scale = OrdinalScale<UIColor>.category10()
                
                let range:[UIColor] = scale.range()
                expect(range.count) == 10
                
                expect(scale.scale(1)) == scale.scale(11)
            }

        }
    }
}
