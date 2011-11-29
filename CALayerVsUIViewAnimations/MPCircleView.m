//
//  MPCircleView.m
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 11/11/11.
//  Copyright (c) 2011 Mark Pospesel. All rights reserved.
//

#import "MPCircleView.h"

@implementation MPCircleView

@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [color release]; color = nil;
    
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[self color] set];
    CGContextAddEllipseInRect(context, [self bounds]);
    CGContextFillPath(context);
}

@end
