//
//  OrdinalScaleTest.swift
//  D2Layers
//
//  Created by Michael Seemann on 24.11.15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import D2Layers

class OrdinalScaleSpec: QuickSpec {
    
    override func spec() {

        describe("domain"){
            it("should default to an empty array"){
                let scale = OrdinalScale<Int, String>()
                expect(scale.domain().count) == 0
            }
            
            it("should forget previous values if domain ist set"){
                let x = OrdinalScale<Int, String>().range(["foo", "bar"])
                
                expect(x.scale(1)) == "foo"
                expect(x.scale(0)) == "bar"
                
                expect(x.domain()) == [1, 0]
                
                x.domain([0, 1])
                
                expect(x.scale(0)) == "foo" // it changed!
                expect(x.scale(1)) == "bar"
                expect(x.domain()) == [0, 1]
            }
            it("should order domain values by the order in which they are seen") {
                let x = OrdinalScale<String, String>()
                x.scale("foo")
                x.scale("bar")
                x.scale("baz")
                expect(x.domain()) == ["foo", "bar", "baz"]
                
                x.domain(["baz", "bar"])
                x.scale("foo")
                expect(x.domain()) == ["baz", "bar", "foo"]
                    
                x.domain(["baz", "foo"])
                expect(x.domain()) == ["baz", "foo"]
                
                x.domain([])
                x.scale("foo")
                x.scale("bar")
                expect(x.domain()) == ["foo", "bar"]
            }
        }
        
        describe("range"){
            
            it("should default to an empty array"){
                let x = OrdinalScale<Int, String>()
                expect(x.range().count) == 0
            }
            
            it("should apend new input values to the domain"){
                let x = OrdinalScale<Int, String>().range(["foo", "bar"])
              
                expect(x.scale(0)) == "foo"
                expect(x.domain()) == [0]
                
                expect(x.scale(1)) == "bar"
                expect(x.domain()) == [0, 1]
              
                expect(x.scale(0)) == "foo"
                expect(x.domain()) == [0, 1]
            }
            
            
            it("should remember previous values if the range is set"){
                let x = OrdinalScale<Int, String>()
                
                expect(x.scale(0)).to(beNil())
                expect(x.scale(1)).to(beNil())
                
                x.range(["foo", "bar"])
                
                expect(x.scale(0)) == "foo"
                expect(x.scale(1)) == "bar"
            }

            it("should work like a circle structure"){
                let x = OrdinalScale<Int, String>().range(["a", "b", "c"])
                
                expect(x.scale(0)) == "a"
                expect(x.scale(1)) == "b"
                expect(x.scale(2)) == "c"
              
                expect(x.scale(3)) == "a"
                expect(x.scale(4)) == "b"
                expect(x.scale(5)) == "c"
   
                expect(x.scale(2)) == "c"
                expect(x.scale(1)) == "b"
                expect(x.scale(0)) == "a"
            }
        }
        
        describe("rangePoints"){
            it("computes discrete points in a continuous range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:0, stop:120)
                expect(x.range()) == [0, 60, 120]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:0, stop:120, padding:1)
                expect(x.range()) == [20, 60, 100]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:0, stop:120, padding:2)
                expect(x.range()) == [30, 60, 90]
            }
            
            it("correctly handles empty domains") {
                let x = try! OrdinalScale<String, Int>().domain([]).rangePoints(start:0, stop:120)
                expect(x.range()) == []
                expect(x.scale("b")).to(beNil())
                expect(x.domain()) == []
            }
            
            it("correctly handles singleton domains") {
                let x = try! OrdinalScale<String, Double>().domain(["a"]).rangePoints(start:0, stop:120)
                expect(x.range()) == [60]
                expect(x.scale("b")).to(beNil())
                expect(x.domain()) == ["a"]
            }
            
            it("can be set to a descending range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:120, stop:0)
                expect(x.range()) == [120, 60, 0]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:120, stop:0, padding:1)
                expect(x.range()) == [100, 60, 20]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:120, stop:0, padding:2)
                expect(x.range()) == [90, 60, 30]
            }
            
            it("has a rangeBand of zero") {
                let x = try! OrdinalScale<String, Int>().domain(["a", "b", "c"]).rangePoints(start:0, stop:120)
                expect(x.rangeBand) == 0
            }
            
            it("returns undefined for values outside the domain") {
                let x = try! OrdinalScale<String, Int>().domain(["a", "b", "c"]).rangePoints(start:0, stop:1)
                expect(x.scale("d")).to(beNil())
                expect(x.scale("e")).to(beNil())
                expect(x.scale("f")).to(beNil())
            }
            
            it("does not implicitly add values to the domain") {
                let x = try! OrdinalScale<String, Int>().domain(["a", "b", "c"]).rangePoints(start:0, stop:1)
                x.scale("d")
                x.scale("e")
                expect(x.domain()) == ["a", "b", "c"]
            }
            
            it("supports realy double values") {
                let o = try! OrdinalScale<Double, Double>().domain([1, 2, 3, 4]).rangePoints(start:0, stop:100)
                expect(o.range()[1]) == 100/3
            }
        }
        
        describe("rangeRoundPoints") {
            
        }
    }
}

