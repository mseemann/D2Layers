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
                let x = try! OrdinalScale<String, Double>().domain([]).rangePoints(start:0, stop:120)
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
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:0, stop:120)
                expect(x.rangeBand) == 0
            }
            
            it("returns undefined for values outside the domain") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:0, stop:1)
                expect(x.scale("d")).to(beNil())
                expect(x.scale("e")).to(beNil())
                expect(x.scale("f")).to(beNil())
            }
            
            it("does not implicitly add values to the domain") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:0, stop:1)
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
            
            it("computes discrete points in a continuous range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:120)
                expect(x.range()) == [0, 60, 120]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:120, padding:1)
                expect(x.range()) == [20, 60, 100]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:120, padding:2);
                expect(x.range()) == [30, 60, 90]
            }
            
            it("rounds to the nearest equispaced integer values") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:119)
                expect(x.range()) == [1, 60, 119]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:119, padding:1)
                expect(x.range()) == [21, 60, 99]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:119, padding:2)
                expect(x.range()) == [31, 60, 89]
            }
            
            it("correctly handles empty domains") {
                let x = try! OrdinalScale<String, Double>().domain([]).rangeRoundPoints(start:0, stop:119)
                expect(x.range()) == []
                expect(x.scale("b")).to(beNil())
                expect(x.domain()) == []
            }
            
            it("correctly handles singleton domains") {
                let x = try! OrdinalScale<String, Double>().domain(["a"]).rangeRoundPoints(start:0, stop:119)
                expect(x.range()) == [60]
                expect(x.scale("b")).to(beNil())
                expect(x.domain()) == ["a"]
            }
            
            it("can be set to a descending range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:119, stop:0)
                expect(x.range()) == [119, 60, 1]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:119, stop:0, padding:1)
                expect(x.range()) == [99, 60, 21]
                
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:119, stop:0, padding:2)
                expect(x.range()) == [89, 60, 31]
            }
            
            it("has a rangeBand of zero") {
                let x =  try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:119)
                expect(x.rangeBand) == 0
            }
            
            it("returns nul for values outside the domain")  {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:1)
                expect(x.scale("d")).to(beNil())
                expect(x.scale("e")).to(beNil())
                expect(x.scale("f")).to(beNil())
            }
            
            it("does not implicitly add values to the domain") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundPoints(start:0, stop:1)
                x.scale("d")
                x.scale("e")
                expect(x.domain()) == ["a", "b", "c"]
            }
        }
        
        describe("rangeBands") {
            it("computes discrete bands in a continuous range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:0, stop:120)
                expect(x.range()) ==  [0, 40, 80]
                expect(x.rangeBand) == 40
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:0, stop:120, padding:0.2, outerPadding:0.2)
                expect(x.range()) == [7.5, 45, 82.5]
                expect(x.rangeBand) ==  30
            }
    
// FIXME currently not possible - maybe every range-funktion must be an object to recompute the ranges with the original values.
//            it("setting domain recomputes range bands") {
//                let x = try! OrdinalScale<String, Double>().rangeBands(start:0, stop:100).domain(["a", "b", "c"])
//                expect(x.range()) == [1, 34, 67]
//                expect(x.rangeBand) == 33
//                x.domain(["a", "b", "c", "d"])
//                expect(x.range()) == [0, 25, 50, 75]
//                expect(x.rangeBand) == 25
//            }
            
            it("can be set to a descending range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:120, stop:0)
                expect(x.range()) == [80, 40, 0]
                expect(x.rangeBand) == 40
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:120, stop:0, padding:0.2, outerPadding:0.2)
                expect(x.range()) == [82.5, 45, 7.5]
                expect(x.rangeBand) == 30
            }
            
            it("can specify a different outer padding") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:120, stop:0, padding:0.2, outerPadding:0.1)
                expect(x.range()) == [84, 44, 4]
                expect(x.rangeBand) == 32
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:120, stop:0, padding:0.2, outerPadding:1)
                expect(x.range()) == [75, 50, 25]
                expect(x.rangeBand) == 20
            }
            
            it("returns undefined for values outside the domain") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:0, stop:1)
                expect(x.scale("d")).to(beNil())
                expect(x.scale("e")).to(beNil())
                expect(x.scale("f")).to(beNil())
            }
            
            it("does not implicitly add values to the domain") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:0, stop:1)
                x.scale("d")
                x.scale("e")
                expect(x.domain()) == ["a", "b", "c"]
            }
        }
        
        describe("rangeRoundBands"){
            it("computes discrete rounded bands in a continuous range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:0, stop:100)
                expect(x.range()) == [1, 34, 67]
                expect(x.rangeBand) == 33
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:0, stop:100, padding:0.2, outerPadding:0.2)
                expect(x.range()) == [7, 38, 69]
                expect(x.rangeBand) == 25
            }
            
            it("can be set to a descending range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:100, stop:0)
                expect(x.range()) == [67, 34, 1]
                expect(x.rangeBand) == 33
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:100, stop:0, padding:0.2, outerPadding:0.2)
                expect(x.range()) == [69, 38, 7]
                expect(x.rangeBand) == 25
            }
            
            it("can specify a different outer padding") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:120, stop:0, padding:0.2, outerPadding:0.1)
                expect(x.range()) == [84, 44, 4]
                expect(x.rangeBand) == 32
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:120, stop:0, padding:0.2, outerPadding:1)
                expect(x.range()) == [75, 50, 25]
                expect(x.rangeBand) == 20
            }
            
            it("returns undefined for values outside the domain"){
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:0, stop:1)
                expect(x.scale("d")).to(beNil())
                expect(x.scale("e")).to(beNil())
                expect(x.scale("f")).to(beNil())
            }
            
            it("does not implicitly add values to the domain") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:0, stop:1)
                x.scale("d")
                x.scale("e")
                expect(x.domain()) == ["a", "b", "c"]
            }
        }
        
        describe("rangeExtent") {
            it("returns the continuous range") {
                var x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangePoints(start:20, stop:120)
                expect(x.rangeExtent) == [20, 120]
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:10, stop:110)
                expect(x.rangeExtent) == [10, 110]
                x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeRoundBands(start:0, stop:100)
                expect(x.rangeExtent) == [0, 100]
                x = OrdinalScale<String, Double>().domain(["a", "b", "c"]).range([0, 20, 100])
                expect(x.rangeExtent) ==  [0, 100]
            }
            
            it("can handle descending ranges") {
                let x = try! OrdinalScale<String, Double>().domain(["a", "b", "c"]).rangeBands(start:100, stop:0)
                expect(x.rangeExtent) == [0, 100]
            }
        }
    }
}

