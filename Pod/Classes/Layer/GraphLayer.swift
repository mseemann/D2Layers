//
//  GraphLayer.swift
//  Pods
//
//  Created by Michael Seemann on 23.11.15.
//
//

import Foundation


class GraphLayer: CALayer {
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.frame = (superlayer?.bounds)!
    }
    
}