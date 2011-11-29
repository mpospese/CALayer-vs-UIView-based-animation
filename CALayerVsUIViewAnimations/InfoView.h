//
//  InfoView.h
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 11/29/11.
//  Copyright (c) 2011 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIViewController

- (id)init;
- (CGSize)contentSizeForViewInPopover;
@property (retain, nonatomic) IBOutlet UITextView *label;

@end
