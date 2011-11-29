//
//  MPExpanderButton.m
//  CALayerVsUIViewAnimations
//
//  Created by Mark Pospesel on 11/9/11.
//  Copyright (c) 2011 Mark Pospesel. All rights reserved.
//

#import "MPExpanderButton.h"
#import <QuartzCore/QuartzCore.h>

#define LABEL_TAG 2000
#define IMAGE_TAG 2001

#define DEFAULT_LEFT_GAP 5
#define DEFAULT_RIGHT_GAP 5
#define DEFAULT_TOP_GAP 3
#define DEFAULT_BOTTOM_GAP 3
#define DEFAULT_IMAGE_GAP 10
#define DEFAULT_IMAGE_WIDTH 20
#define DEFAULT_IMAGE_HEIGHT 20

@interface MPExpanderButton(Private)

@property (nonatomic, retain) UIButton* button;
@property (nonatomic, retain) UILabel* textLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) MPCircleView* imageBackground;
@property (nonatomic, retain) UIColor* oldBackgroundColor;
@property (nonatomic, retain) UIColor* oldTextColor;

- (void)rotateTo:(CGFloat)angle;
- (void)resize;

@end

@implementation MPExpanderButton
{
    UIButton* _button;
    UILabel* _textLabel;
    UIImageView* _imageView;    
    MPCircleView* _imageBackground;
    UIColor* _oldBackgroundColor;
    UIColor* _oldTextColor;
    CGFloat leftGap;
    CGFloat rightGap;
    CGFloat topGap;
    CGFloat bottomGap;
    CGFloat imageGap;
    CGSize imageSize;
}

@synthesize delegate;
@synthesize isExpanded;
@synthesize expandedText;
@synthesize collapsedText;

@synthesize useCoreAnimation;
@synthesize animateOnTouchDown;

- (BOOL)isCollapsed
{
    return !isExpanded;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
    [self resize];
}

- (void)setExpandedText:(NSString *)newValue
{
    if (expandedText != newValue)
    {
        id oldValue = expandedText;
        expandedText = [newValue copy];
        [oldValue release];
        if (isExpanded)
            [self setText:expandedText];
    }
}

- (void)setCollapsedText:(NSString *)newValue
{
    if (collapsedText != newValue)
    {
        id oldValue = collapsedText;
        collapsedText = [newValue copy];
        [oldValue release];
        if (!isExpanded)
            [self setText:collapsedText];
    }
}

#pragma mark - Construction / Destruction

- (void)doInit
{
    // Initialization code
    leftGap = DEFAULT_LEFT_GAP;
    rightGap = DEFAULT_RIGHT_GAP;
    topGap = DEFAULT_TOP_GAP;
    bottomGap = DEFAULT_BOTTOM_GAP;
    imageGap = DEFAULT_IMAGE_GAP;
    imageSize = CGSizeMake(DEFAULT_IMAGE_WIDTH, DEFAULT_IMAGE_HEIGHT);
    collapsedText = [@"More" copy];
    expandedText = [@"Less" copy];
    
    _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [[self layer] setCornerRadius:6];
    
    _textLabel = [[UILabel alloc] init];
    [_textLabel setText:collapsedText];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = UITextAlignmentCenter;
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.tag = LABEL_TAG;
    [_textLabel sizeToFit];
    
    _imageBackground  = [[MPCircleView alloc] init];
    [_imageBackground setBackgroundColor:[UIColor clearColor]];
    [_imageBackground setColor:[UIColor whiteColor]];
    [_imageBackground setHidden:YES];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"23-circle-south"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.tag = IMAGE_TAG;
    
    [_button addSubview:_textLabel];
    [_button addSubview:_imageBackground];
    [_button addSubview:_imageView];
    
    [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [_button addTarget:self action:@selector(buttonUntouched:) forControlEvents:  UIControlEventTouchUpOutside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
    
    [self addSubview:_button];
    [self resize];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doInit];
    }
    return self;    
}

- (void)dealloc
{
    [_textLabel release]; _textLabel = nil;
    [_imageView release]; _imageView = nil;
    [_button release]; _button = nil;
    delegate = nil;
    [_imageBackground release]; _imageBackground = nil;
    [_oldBackgroundColor release]; _oldBackgroundColor = nil;
    [_oldTextColor release]; _oldTextColor = nil;
    [expandedText release]; expandedText = nil;
    [collapsedText release]; collapsedText = nil;
    
    [super dealloc];
}

#pragma mark - Instance Methods

- (void)expand
{
    isExpanded = YES;
    [self rotateTo:-M_PI];
    [self setText:[self expandedText]];
}

- (void)collapse
{
    isExpanded = NO;
    [self rotateTo:0];
    [self setText:[self collapsedText]];
}

#pragma mark - Touch events

- (void)buttonTouched:(id)sender
{
    [self setOldBackgroundColor:[self backgroundColor]];
    [self setOldTextColor:[self textColor]];
    [self setBackgroundColor:[UIColor darkGrayColor]];
    [self setTextColor:[UIColor whiteColor]];
    [[self imageBackground] setHidden:NO];
    if ([self animateOnTouchDown])
        [self rotateTo:-M_PI/2];
}

- (void)setUntouched:(BOOL)animate
{
    [self setBackgroundColor:[self oldBackgroundColor]];
    [self setTextColor:[self oldTextColor]];
    [[self imageBackground] setHidden:YES];
    if (animate)
        [self rotateTo:[self isExpanded]? -M_PI : 0];
}

- (void)buttonUntouched:(id)sender
{
    [self setUntouched:YES];
}

- (void)buttonPressed:(id)sender
{
    [self setUntouched:NO];
    if (isExpanded)
    {
        [self collapse];
        if (delegate != nil)
            [delegate didCollapse:self];
    }
    else
    {
        [self expand];
        if (delegate != nil)
            [delegate didExpand:self];
    }
}

#pragma mark - Properties

- (UIFont*)font
{
    return [[self textLabel] font];
}

- (void)setFont:(UIFont *)font
{
    [[self textLabel] setFont:font];
}

- (UIColor*)textColor
{
    return [[self textLabel] textColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    [[self textLabel] setTextColor:textColor];
}

@end

@implementation MPExpanderButton(Private)

#pragma mark - Private Properties

// unfortunately synthesize doesn't work in categories, so have to 
// manually implement property getters and setters

- (UIButton*)button
{
    return _button;
}

- (void)setButton:(UIButton *)newValue
{
    if (_button != newValue)
    {
        id oldValue = _button;
        _button = [newValue retain];
        [oldValue release];
    }
}

- (UILabel*)textLabel
{
    return _textLabel;
}

- (void)setTextLabel:(UILabel *)newValue
{
    if (_textLabel != newValue)
    {
        id oldValue = _textLabel;
        _textLabel = [newValue retain];
        [oldValue release];
    }
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)setImageView:(UIImageView *)newValue  
{
    if (_imageView != newValue)
    {
        id oldValue = _imageView;
        _imageView = [newValue retain];
        [oldValue release];
    }
}

- (MPCircleView*)imageBackground
{
    return _imageBackground;
}

- (void)setImageBackground:(MPCircleView *)newValue  
{
    if (_imageBackground != newValue)
    {
        id oldValue = _imageBackground;
        _imageBackground = [newValue retain];
        [oldValue release];
    }
}

- (UIColor*)oldBackgroundColor
{
    return _oldBackgroundColor;
}

- (void)setOldBackgroundColor:(UIColor *)newValue
{
    if (_oldBackgroundColor != newValue)
    {
        id oldValue = _oldBackgroundColor;
        _oldBackgroundColor = [newValue retain];
        [oldValue release];
    }
}

- (UIColor*)oldTextColor
{
    return _oldTextColor;
}

- (void)setOldTextColor:(UIColor *)newValue
{
    if (_oldTextColor != newValue)
    {
        id oldValue = _oldTextColor;
        _oldTextColor = [newValue retain];
        [oldValue release];
    }
}

#pragma mark - Private Methods

- (void)rotateTo:(CGFloat)angle
{
    if ([self useCoreAnimation])
    {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.25;
        animation.fillMode = kCAFillModeForwards;
        id toValue;
        animation.fromValue = [NSValue valueWithCATransform3D:self.imageView.layer.transform];
        if (angle == 0)
            toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        else
            toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, angle, 0, 0, 1)];
        animation.toValue = toValue;
        [self.imageView.layer addAnimation:animation forKey:@"animateTransform"];
        self.imageView.layer.transform = [toValue CATransform3DValue];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            if (angle == 0)
                self.imageView.transform = CGAffineTransformIdentity;
            else
                self.imageView.transform = CGAffineTransformMakeRotation(angle);
        }];
    }
}

- (void)resize
{
    [self.textLabel sizeToFit];
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(self.textLabel.bounds.size.width + leftGap + imageGap + imageSize.width + rightGap, self.textLabel.bounds.size.height + topGap + bottomGap);
    self.frame = frame;
    self.button.frame = self.bounds;
    
    CGRect imageRect = CGRectMake(self.textLabel.bounds.size.width + leftGap + imageGap, (self.frame.size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
    self.imageView.frame = imageRect;
    CGRect imageBackgroundRect = CGRectInset(imageRect, 1, 1);
    self.imageBackground.frame = imageBackgroundRect;
    
    CGRect textRect = self.textLabel.frame;
    textRect.origin = CGPointMake(leftGap, topGap);
    self.textLabel.frame = textRect;
}

@end

