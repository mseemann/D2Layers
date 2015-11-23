//
//  Color.swift
//  TestGraphics
//
//  Created by Michael Seemann on 06.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    /**
     Convenience initalizer that creates a uicolor from a 6 digit hex value. 0xff0000 -> red.
     - Parameter rgb: the rgb hex value
    */
    convenience init(rgb: UInt32) {
        self.init(
            red:    CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green:  CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue:   CGFloat(rgb & 0x0000FF) / 255.0,
            alpha:  CGFloat(1.0)
        )
    }
    
    /**
        Makes a color brighter with the provided gamma value (defaults to 1). every color component is devided by 0.7^gamma. 
        - Parameter gamma: specifies how brighter the color should be. a greater value results to a brighter color.
     
    */
    public func brighter(gamma:Float = 1) -> UIColor {
        
        var red:CGFloat     = 0
        var green:CGFloat   = 0
        var blue:CGFloat    = 0
        var alpha:CGFloat   = 0
        let defaultComponentValue:CGFloat = 30.0/255.0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let k = CGFloat(pow(0.7, gamma))

        red = red < defaultComponentValue ? defaultComponentValue : red
        green = green < defaultComponentValue ? defaultComponentValue : green
        blue = blue < defaultComponentValue ? defaultComponentValue : blue
        
        return UIColor(red: min(1, red/k), green: min(1, green/k), blue: min(1, blue/k), alpha: alpha)
    }
    
    /**
     Makes a color darker with the provided gamma value (defaults to 1). every color component is multiplied by 0.7^gamma.
     - Parameter gamma: specifies how darker the color should be. a greater value results to a darker color.
     
     */
    public func darker(gamma:Float = 1) -> UIColor {
        var red:CGFloat     = 0
        var green:CGFloat   = 0
        var blue:CGFloat    = 0
        var alpha:CGFloat   = 0
    
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
        let k = CGFloat(pow(0.7, gamma))
    
        return UIColor(red: red*k, green: green*k, blue: blue*k, alpha: alpha)
    }
    
    /**
     Decompose a UIColor in the red, green and blue component. Evenery component has a value between 0.0 and 1.0.
     - Returns: a tupel with the red, green and blue component.
    */
    public func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat) {
        var red:CGFloat     = 0
        var green:CGFloat   = 0
        var blue:CGFloat    = 0
        var alpha:CGFloat   = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue)
    }

}

///This product includes colorspecifications and designs developed by Cynthia Brewer (http://colorbrewer.org/).
public struct Colors {
    
    public static let category10:[UInt32]  = [0x1f77b4, 0xff7f0e, 0x2ca02c, 0xd62728,
                                                0x9467bd, 0x8c564b, 0xe377c2, 0x7f7f7f,
                                                0xbcbd22, 0x17becf]
    
    public static let category20:[UInt32]  = [0x1f77b4, 0xaec7e8, 0xff7f0e, 0xffbb78,
                                                0x2ca02c, 0x98df8a, 0xd62728, 0xff9896,
                                                0x9467bd, 0xc5b0d5, 0x8c564b, 0xc49c94,
                                                0xe377c2, 0xf7b6d2, 0x7f7f7f, 0xc7c7c7,
                                                0xbcbd22, 0xdbdb8d, 0x17becf, 0x9edae5]
    
    public static let category20b:[UInt32] = [0x393b79, 0x5254a3, 0x6b6ecf, 0x9c9ede,
                                                0x637939, 0x8ca252, 0xb5cf6b, 0xcedb9c,
                                                0x8c6d31, 0xbd9e39, 0xe7ba52, 0xe7cb94,
                                                0x843c39, 0xad494a, 0xd6616b, 0xe7969c,
                                                0x7b4173, 0xa55194, 0xce6dbd, 0xde9ed6]
    
    public static let category20c:[UInt32] = [0x3182bd, 0x6baed6, 0x9ecae1, 0xc6dbef,
                                                0xe6550d, 0xfd8d3c, 0xfdae6b, 0xfdd0a2,
                                                0x31a354, 0x74c476, 0xa1d99b, 0xc7e9c0,
                                                0x756bb1, 0x9e9ac8, 0xbcbddc, 0xdadaeb,
                                                0x636363, 0x969696, 0xbdbdbd, 0xd9d9d9]
}