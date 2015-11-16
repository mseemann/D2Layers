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
#import "CustomAnimLayer.h"

@interface CustomAnimPieLayer : CustomAnimLayer


@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat outerRadius;


@end

#endif /* CustomAnimPieLayer_h */
