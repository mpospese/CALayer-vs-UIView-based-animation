//
//  CALayerVsUIViewAnimationsViewController.m
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 9/27/11.
//  Copyright 2011 Mark Pospesel. All rights reserved.
//

#import "CALayerVsUIViewAnimationsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoView.h"

@implementation CALayerVsUIViewAnimationsViewController
{
    CGFloat collapsedHeight;    
}

@synthesize button1;
@synthesize button2;
@synthesize textView1;
@synthesize textView2;
@synthesize popover;

- (void)dealloc {
    [button1 release]; button1 = nil;
    [button2 release]; button2 = nil;
    [textView1 release]; textView1 = nil;
    [textView2 release]; textView2 = nil;
    [popover release]; popover = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.button1 setFont:[UIFont boldSystemFontOfSize:15]];
    [self.button2 setFont:[UIFont boldSystemFontOfSize:15]];
    [self.button1 setTextColor:[UIColor darkGrayColor]];
    [self.button2 setTextColor:[UIColor darkGrayColor]];
    [[self button1] setDelegate:self];
    [[self button2] setDelegate:self];
    [[self button1] setUseCoreAnimation:NO];
    [[self button2] setUseCoreAnimation:YES];
    [[self button1] setAnimateOnTouchDown:YES];
    [[self button2] setAnimateOnTouchDown:YES];
    collapsedHeight = [[self textView1] frame].size.height;
}

- (void)viewDidUnload
{
    [[self button1] setDelegate:nil];
    [[self button2] setDelegate:nil];
    
    [self setButton1:nil];
    [self setButton2:nil];
    [self setTextView1:nil];
    [self setTextView2:nil];
    [self setPopover:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)textView:(UITextView*)textView expand:(BOOL)expand
{
    CGRect textRect = [textView frame];
    if (expand)
        textRect.size.height = self.view.bounds.size.height - textRect.origin.y - 20;
    else
        textRect.size.height = collapsedHeight;
    [textView setFrame:textRect];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([[self button1] isExpanded])
    {
        [self textView:[self textView1] expand:YES];
    }
    
    if ([[self button2] isExpanded])
    {
        [self textView:[self textView2] expand:YES];            
    }
}

#pragma mark - Event Handlers

- (IBAction)valueChangedSwitch1:(id)sender 
{
    [[self button1] setAnimateOnTouchDown:[sender isOn]];
}

- (IBAction)valueChangedSwitch2:(id)sender 
{
    [[self button2] setAnimateOnTouchDown:[sender isOn]];
}

- (IBAction)touchUpInsideInfoButton:(id)sender {
    if ([self popover] == nil)
    {
        id content = [[InfoView alloc] init];
        [self setPopover:[[[UIPopoverController alloc] initWithContentViewController:content] autorelease]];
         [content release];
    }
    
    [[self popover] presentPopoverFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - MPExpanderButtonDelegate<NSObject>

-(void)animateTextView:(UITextView*)textView expand:(BOOL)expand
{
    [UIView animateWithDuration:0.25 animations:^{
        [self textView:textView expand:expand];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)didExpand:(MPExpanderButton*)button
{
    UITextView* textView = (button == [self button1])? [self textView1] : [self textView2];
    [self animateTextView:textView expand:YES];
}

-(void)didCollapse:(MPExpanderButton*)button
{
    UITextView* textView = (button == [self button1])? [self textView1] : [self textView2];
    [self animateTextView:textView expand:NO];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setPopover:nil];
}

@end
