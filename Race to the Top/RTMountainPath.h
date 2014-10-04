//
//  RTMountainPath.h
//  Race to the Top
//
//  Created by Robin van 't Slot on 01-10-14.
//  Copyright (c) 2014 BrickInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface RTMountainPath : NSObject

+(NSArray *)mountainPathsForRect:(CGRect)rect;

+(UIBezierPath *)tapTargetForPath:(UIBezierPath *)path;

@end
