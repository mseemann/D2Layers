//
//  D2LayerSelection.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation

public class D2LayerSelection<T> {
    
    var selected:[T] = []
    var askIndexes = Set<Int>()
    
    func add(graph:T){
        selected.append(graph)
    }
    
    func add(selection: D2LayerSelection<T>) {
        selected.appendContentsOf(selection.all())
    }
    
    
    func hasIndex(i:Int) -> Bool {
        askIndexes.insert(i)
        return i < selected.count
    }
    
    func get(i:Int) -> T {
        return selected[i]
    }
    
    func getUnAskedGraphs() -> [T] {
        var result: [T] = []
        
        for (index, g) in selected.enumerate() {
            if !askIndexes.contains(index){
                result.append(g)
            }
        }
        
        return result
    }
    
    public func all() -> [T]{
        return selected
    }
}