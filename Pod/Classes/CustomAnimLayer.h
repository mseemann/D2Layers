//
//  CustomAnimLayer.h
//  Pods
//
//  Created by Michael Seemann on 08.11.15.
//
//

#ifndef CustomAnimLayer_h
#define CustomAnimLayer_h


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomAnimLayer : CALayer

@property (nonatomic) CGColorRef fillColor;
@property (nonatomic) CGColorRef strokeColor;
@property (nonatomic) CGFloat strokeWidth;


@end

#endif /* CustomAnimLayer_h */
