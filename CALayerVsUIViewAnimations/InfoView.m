//
//  InfoView.m
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 11/29/11.
//  Copyright (c) 2011 Mark Pospesel. All rights reserved.
//

#import "InfoView.h"

#define LABEL_GAP 20
#define LABEL_WIDTH 200

@implementation InfoView
@synthesize label;

- (id)init
{
    self = [super initWithNibName:@"InfoView" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [label setText:@"Background and Arrow Icon by Glyphish\n\nwww.glyphish.com"];
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (CGSize)contentSizeForViewInPopover
{
    CGSize size = [[[self label] text] sizeWithFont:[[self label] font] constrainedToSize:CGSizeMake(LABEL_WIDTH, 480) lineBreakMode:UILineBreakModeWordWrap];
    return CGSizeMake(size.width + LABEL_GAP*2, size.height + LABEL_GAP*2);
}

- (void)dealloc {
    [label release];
    [super dealloc];
}
@end
