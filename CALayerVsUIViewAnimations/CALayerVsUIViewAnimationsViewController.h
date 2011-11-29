//
//  CALayerVsUIViewAnimationsViewController.h
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 9/27/11.
//  Copyright 2011 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPExpanderButton.h"

@interface CALayerVsUIViewAnimationsViewController : UIViewController<MPExpanderButtonDelegate>

@property (retain, nonatomic) IBOutlet MPExpanderButton *button1;
@property (retain, nonatomic) IBOutlet MPExpanderButton *button2;
@property (retain, nonatomic) IBOutlet UITextView *textView1;
@property (retain, nonatomic) IBOutlet UITextView *textView2;
@property (retain, nonatomic) UIPopoverController* popover;

- (IBAction)valueChangedSwitch1:(id)sender;
- (IBAction)valueChangedSwitch2:(id)sender;
- (IBAction)touchUpInsideInfoButton:(id)sender;

#pragma mark - MPExpanderButtonDelegate<NSObject>

- (void)didExpand:(MPExpanderButton*)button;
- (void)didCollapse:(MPExpanderButton*)button;

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;

@end
