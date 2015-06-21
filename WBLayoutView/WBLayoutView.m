//
//  WBLayoutView.m
//  WBLayoutView
//
//  Created by Scott Chandler on 6/15/15.
//  Copyright (c) 2015 Wooly Beast Software LLC. All rights reserved.
//

#import "WBLayoutView.h"
#import "WBLayoutAnchor.h"
#import <QuartzCore/QuartzCore.h>

@interface WBLayoutView()
@property (nonatomic) NSArray *layoutConstraints;

- (CGSize)calculateMinimumViewSize;
- (NSArray *)constraintsForView:(UIView *)view relativeToPreviousView:(UIView *)previousView;
@end

#define	UILayoutConstraintAxisIsHorizontal(axis)		(axis==UILayoutConstraintAxisHorizontal)
#define UILayoutConstraintAxisIsVertical(axis)		(axis==UILayoutConstraintAxisVertical)

@implementation WBLayoutView
+ (Class)layerClass
{
	return [CATransformLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if ( self = [super initWithFrame:frame], self ) {
		_arrangedSubviews = @[];
	}
	return self;
}

- (void)willRemoveSubview:(UIView *)subview
{
	[super willRemoveSubview:subview];
	[self removeArrangedSubview:subview];
	[self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
	[super updateConstraints];
	
	// calculate new constraints...
	NSMutableArray *constraints = [NSMutableArray new];
	NSArray *views = self.arrangedSubviews;
	UIView *previousView = nil;
	for ( UIView *view in views ) {
		NSArray *viewConstraints = [self constraintsForView:view relativeToPreviousView:previousView];
		[constraints addObjectsFromArray:viewConstraints];
		previousView = view;
	}

	// remove our old constraints...
	if ( self.layoutConstraints ) {
		[self removeConstraints:self.layoutConstraints];
	}
	self.layoutConstraints = nil;

	// check that we have any constraints...
	if ( constraints.count > 0 ) {
		// adjust our size if neccessary...
		CGSize size = [self calculateMinimumViewSize];
		CGRect bounds = self.bounds;
		if ( size.width > CGRectGetWidth(bounds) || size.height > CGRectGetHeight(bounds)) {
			bounds.size.width = MAX(CGRectGetWidth(bounds), size.width);
			bounds.size.height = MAX(CGRectGetHeight(bounds),size.height);
			self.bounds = bounds;
		}
		
		// set our new constraints...
		self.layoutConstraints = constraints;
		[self addConstraints:self.layoutConstraints];
	}
}

- (NSArray *)constraintsForView:(UIView *)view relativeToPreviousView:(UIView *)previousView
{
	NSMutableArray *constraints = [NSMutableArray array];
	BOOL isVerticalAxis = UILayoutConstraintAxisIsVertical(self.axis);
	
	NSLayoutAttribute layoutAttribute = NSLayoutAttributeNotAnAttribute;

	WBLayoutViewAlignment alignment = self.alignment;
	CGFloat spacing = self.spacing;
	switch ( alignment ) {
		case WBLayoutViewAlignmentFill : {
			NSLayoutAttribute edge1Attribute = (isVerticalAxis) ? NSLayoutAttributeLeading : NSLayoutAttributeTop;
			NSLayoutAttribute edge2Attribute = (isVerticalAxis) ? NSLayoutAttributeTrailing : NSLayoutAttributeBottom;
			
			NSArray *fillConstraints = @[
										 [[view anchorForLayoutAttribute:edge1Attribute] constraintEqualToAnchor:[self anchorForLayoutAttribute:edge1Attribute]],
										 [[view anchorForLayoutAttribute:edge2Attribute] constraintEqualToAnchor:[self anchorForLayoutAttribute:edge2Attribute]]
										 ];
			[constraints addObjectsFromArray:fillConstraints];
			// fall through to leading to catch the 'pin edge'
		}
		case WBLayoutViewAlignmentLeading :
			layoutAttribute = (isVerticalAxis) ? NSLayoutAttributeLeading : NSLayoutAttributeTop;
			break;
			
		case WBLayoutViewAlignmentTrailing :
			layoutAttribute = (isVerticalAxis) ? NSLayoutAttributeTrailing : NSLayoutAttributeBottom ;
			break;
			
		case WBLayoutViewAlignmentCenter :
			layoutAttribute = (isVerticalAxis) ? NSLayoutAttributeCenterX : NSLayoutAttributeCenterY;
			spacing = 0.0;
			break;
	}

	NSAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute,@"Invalid attrbute");
	WBLayoutAnchor *viewAnchor = [view anchorForLayoutAttribute:(isVerticalAxis) ? NSLayoutAttributeTop : NSLayoutAttributeLeading];
	WBLayoutAnchor *previousViewAnchor = nil;

	if ( ! previousView ) {
		previousViewAnchor = [self anchorForLayoutAttribute: (isVerticalAxis) ? NSLayoutAttributeTop : NSLayoutAttributeLeading];
	}
	else {
		previousViewAnchor =  [previousView anchorForLayoutAttribute:(isVerticalAxis) ? NSLayoutAttributeBottom : NSLayoutAttributeTrailing];
	}

	[constraints addObjectsFromArray:@[[viewAnchor constraintEqualToAnchor:previousViewAnchor constant:self.spacing],
									   [[view anchorForLayoutAttribute:layoutAttribute] constraintEqualToAnchor:[self anchorForLayoutAttribute:layoutAttribute] constant:spacing]]];
	
	return constraints;
}

#pragma mark -

- (CGSize)calculateMinimumViewSize
{
	BOOL isVerticalAxis = UILayoutConstraintAxisIsVertical(self.axis);
	CGFloat spacing = ( self.alignment == WBLayoutViewAlignmentLeading || self.alignment == WBLayoutViewAlignmentTrailing ) ? self.spacing : 0.0;

	CGFloat width = 0.0, height = 0.0;
	for ( UIView *view in self.arrangedSubviews ) {
		CGSize viewSize = [view intrinsicContentSize];
		if ( isVerticalAxis ) {
			width = MAX(width,viewSize.width + spacing);
			height += viewSize.height+self.spacing;
		}
		else {
			width += viewSize.width+self.spacing;
			height = MAX(height, viewSize.height + spacing);
		}
	}
	
	CGSize size = (CGSize){width,height};
	
	return size;
}

- (void)addArrangedSubview:(UIView *)subview
{
	if ( ![self.arrangedSubviews containsObject:subview] ) {
		self.arrangedSubviews = [self.arrangedSubviews arrayByAddingObject:subview];
		[self addSubview:subview];
		[self setNeedsUpdateConstraints];
	}
}

- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index
{
	if ( ![self.arrangedSubviews containsObject:subview] ) {
		self.arrangedSubviews = [self.arrangedSubviews arrayByAddingObject:subview];
		[self insertSubview:subview atIndex:index];
		[self setNeedsUpdateConstraints];
	}
}

- (void)removeArrangedSubview:(UIView *)subview
{
	NSMutableArray * subviews = [self.arrangedSubviews mutableCopy];
	[subviews removeObject:subview];
	self.arrangedSubviews = subviews;
}
@end
