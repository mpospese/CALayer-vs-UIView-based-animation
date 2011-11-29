//
//  MPExpanderButton.h
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 11/9/11.
//  Copyright (c) 2011 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MPCircleView.h"

@protocol MPExpanderButtonDelegate;

@interface MPExpanderButton : UIView {
}

// Properties
@property (nonatomic, assign) IBOutlet id<MPExpanderButtonDelegate> delegate;
@property (nonatomic, readonly) BOOL isExpanded;
@property (nonatomic, readonly) BOOL isCollapsed;
@property (nonatomic, copy) NSString* collapsedText;
@property (nonatomic, copy) NSString* expandedText;
@property (retain) UIFont* font;
@property (retain) UIColor* textColor;

@property (nonatomic, assign) BOOL useCoreAnimation;
@property (nonatomic, assign) BOOL animateOnTouchDown;

// Instance Methods
-(void)expand;
-(void)collapse;

@end

// Protocol to get callbacks on expand / collapse
@protocol MPExpanderButtonDelegate<NSObject>

@required
-(void)didExpand:(MPExpanderButton*)button;
-(void)didCollapse:(MPExpanderButton*)button;

@end
