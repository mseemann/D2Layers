//
//  ColorTest.swift
//  D2Layers
//
//  Created by Michael Seemann on 23.11.15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble


@testable import D2Layers

class ColorSpec: QuickSpec {
    
    override func spec() {
        describe("color extensions") {
            
            it("is should make color brighter") {
                let blueColor = UIColor.blueColor()

                let rgbBlue = blueColor.rgb()
                
                expect(rgbBlue.red) == 0
                expect(rgbBlue.green) == 0
                expect(rgbBlue.blue) == 1.0
                
                let lightBlueColor = blueColor.brighter().rgb()
                

                expect(rgbBlue.red) < lightBlueColor.red
                expect(rgbBlue.green) < lightBlueColor.green
                expect(rgbBlue.blue) == lightBlueColor.blue
            }
            
            it("should make color darker") {
                let blueColor = UIColor.blueColor()
                
                let rgbBlue = blueColor.rgb()
                
                expect(rgbBlue.red) == 0
                expect(rgbBlue.green) == 0
                expect(rgbBlue.blue) == 1.0
                
                let darkerBlueColor = blueColor.darker().rgb()
             
                expect(rgbBlue.red) == darkerBlueColor.red
                expect(rgbBlue.green) == darkerBlueColor.green
                expect(rgbBlue.blue) > darkerBlueColor.blue
            }
            
        }
    }
}
