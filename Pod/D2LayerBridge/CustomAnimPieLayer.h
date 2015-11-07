//
//  CustomAnimPieLayer.h
//  TestGraphics
//
//  Created by Michael Seemann on 05.11.15.
//  Copyright © 2015 Michael Seemann. All rights reserved.
//

#ifndef CustomAnimPieLayer_h
#define CustomAnimPieLayer_h

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomAnimPieLayer : CALayer


@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGColorRef fillColor;
@property (nonatomic) CGColorRef strokeColor;
@property (nonatomic) CGFloat strokeWidth;


@end

#endif /* CustomAnimPieLayer_h */
