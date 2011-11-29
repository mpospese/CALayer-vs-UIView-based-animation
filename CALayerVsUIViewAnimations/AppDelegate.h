//
//  AppDelegate.h
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 9/27/11.
//  Copyright 2011 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CALayerVsUIViewAnimationsViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CALayerVsUIViewAnimationsViewController *viewController;

@end
