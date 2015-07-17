//
//  WBLayoutView.m
//  WBLayoutView
//
//  Created by Scott Chandler on 6/15/15.
//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Wooly Beast Software LLC
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

#import "WBLayoutView.h"
#import "WBLayoutAnchor.h"
#import <QuartzCore/QuartzCore.h>

#define _DEBUG_	!0
@interface WBLayoutView()
@property (nonatomic) NSArray *layoutConstraints;

- (NSArray *)constraintsForView:(UIView *)view relativeToPreviousView:(UIView *)previousView withSpacing:(CGFloat)spacing;
- (NSArray *)calculateSpacing;
@end

#define	UILayoutConstraintAxisIsHorizontal(axis)		(axis==UILayoutConstraintAxisHorizontal)
#define UILayoutConstraintAxisIsVertical(axis)		(axis==UILayoutConstraintAxisVertical)

@implementation WBLayoutView
#if !_DEBUG_
+ (Class)layerClass
{
	return [CATransformLayer class];
}
#endif

- (instancetype)initWithFrame:(CGRect)frame
{
	if ( self = [super initWithFrame:frame], self ) {
		_arrangedSubviews = @[];
		_alignment = WBLayoutViewAlignmentCenter;
		_axis = UILayoutConstraintAxisVertical;
		_distribution = WBLayoutViewDistributionEqualSpacing;
		_spacing = 8.0;
#if _DEBUG_
		self.layer.borderColor = [[UIColor redColor] CGColor];
		self.layer.borderWidth = 1.0;
#endif
	}
	return self;
}

- (void)willRemoveSubview:(UIView *)subview
{
	[super willRemoveSubview:subview];
	[self removeArrangedSubview:subview];
	[self setNeedsUpdateConstraints];
}

static BOOL UseStrictSpacing( WBLayoutViewDistribution distribution ) {
	return distribution == WBLayoutViewDistributionFill || distribution == WBLayoutViewDistributionFillEqually || distribution == WBLayoutViewDistributionFillProportionally;
}

- (NSArray *)calculateSpacing
{
	NSMutableArray *spacings = nil;
	NSArray *subviews = self.arrangedSubviews;
	if ( subviews.count ) {
		spacings = [NSMutableArray arrayWithCapacity:subviews.count+1];
		spacings[0] = @(0.0);
		if ( subviews.count > 1 ) {
			CGSize size = [self minimumSizeForArrangedSubviews];
			CGFloat spacing = self.spacing;
			if ( !UseStrictSpacing(self.distribution) ) {
				CGFloat extraSpacing = 0.0;
				if ( self.axis == UILayoutConstraintAxisHorizontal ) {
					extraSpacing = CGRectGetWidth(self.bounds) - size.width;
				}
				else {
					extraSpacing = CGRectGetHeight(self.bounds) - size.height;
				}
				spacing += MAX(0.0,extraSpacing/subviews.count);
			}

			[subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				spacings[idx+1] = @(spacing);
			}];
			spacings[subviews.count] = @(0.0);
			
		}
	}
	
	return spacings;
}

- (void)updateConstraints
{
	[super updateConstraints];
	
	// calculate new constraints...
	NSMutableArray *constraints = [NSMutableArray new];
	NSArray *views = self.arrangedSubviews;
	__block UIView *previousView = nil;
	
	NSArray *spacings = [self calculateSpacing];
	
	[views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
		if ( ![view isHidden] ) {
			CGFloat spacing = [spacings[idx] floatValue];
			
			NSArray *viewConstraints = [self constraintsForView:view relativeToPreviousView:previousView withSpacing:spacing];
			[constraints addObjectsFromArray:viewConstraints];
			previousView = view;
		}
	}];
	
	UIView *lastView = self.arrangedSubviews.lastObject;
	if ( lastView ) {
		
		[lastView.wb_trailingAnchor constraintEqualToAnchor:self.wb_trailingAnchor constant:[spacings.lastObject floatValue]];
	}

	// remove our old constraints...
	if ( self.layoutConstraints ) {
		[self removeConstraints:self.layoutConstraints];
	}

	self.layoutConstraints = nil;

	// check that we have any constraints...
	if ( constraints.count > 0 ) {
		// set our new constraints...
		self.layoutConstraints = constraints;
		[self addConstraints:self.layoutConstraints];
	}
}

- (NSArray *)constraintsForView:(UIView *)view relativeToPreviousView:(UIView *)previousView withSpacing:(CGFloat)spacing
{
	NSMutableArray *constraints = [NSMutableArray array];
	BOOL isVerticalAxis = UILayoutConstraintAxisIsVertical(self.axis);
	
	NSLayoutAttribute layoutAttribute = NSLayoutAttributeNotAnAttribute;

	WBLayoutViewAlignment alignment = self.alignment;
	switch ( alignment ) {
		case WBLayoutViewAlignmentFill : {
			NSLayoutAttribute edge1Attribute = (isVerticalAxis) ? NSLayoutAttributeLeading : NSLayoutAttributeTop;
			NSLayoutAttribute edge2Attribute = (isVerticalAxis) ? NSLayoutAttributeTrailing : NSLayoutAttributeBottom;
			
			NSArray *fillConstraints = @[
										 [[view wb_anchorForLayoutAttribute:edge1Attribute] constraintEqualToAnchor:[self wb_anchorForLayoutAttribute:edge1Attribute]],
										 [[view wb_anchorForLayoutAttribute:edge2Attribute] constraintEqualToAnchor:[self wb_anchorForLayoutAttribute:edge2Attribute]]
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
			break;
	}

	NSAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute,@"Invalid attrbute");
	WBLayoutAnchor *viewAnchor = [view wb_anchorForLayoutAttribute:(isVerticalAxis) ? NSLayoutAttributeTop : NSLayoutAttributeLeading];
	WBLayoutAnchor *previousViewAnchor = nil;

	if ( ! previousView ) {
		previousViewAnchor = [self wb_anchorForLayoutAttribute: (isVerticalAxis) ? NSLayoutAttributeTop : NSLayoutAttributeLeading];
	}
	else {
		previousViewAnchor =  [previousView wb_anchorForLayoutAttribute:(isVerticalAxis) ? NSLayoutAttributeBottom : NSLayoutAttributeTrailing];
	}

	NSLayoutConstraint *intraSubviewConstraint = nil;
	switch ( self.distribution ) {
		case WBLayoutViewDistributionFillProportionally :
			intraSubviewConstraint = [viewAnchor constraintEqualToAnchor:previousViewAnchor constant:spacing];
			break;
			
		case WBLayoutViewDistributionEqualSpacing :
			intraSubviewConstraint = [viewAnchor constraintEqualToAnchor:previousViewAnchor constant:spacing];
			break;

		case WBLayoutViewDistributionEqualCentering :
			intraSubviewConstraint = [viewAnchor constraintGreaterThanOrEqualToAnchor:previousViewAnchor constant:spacing];
			break;
			
	}
	[constraints addObjectsFromArray:@[[viewAnchor constraintEqualToAnchor:previousViewAnchor constant:spacing],
									   [[view wb_anchorForLayoutAttribute:layoutAttribute] constraintEqualToAnchor:[self wb_anchorForLayoutAttribute:layoutAttribute]]]];
	
	return constraints;
}

#pragma mark -

- (CGSize)minimumSizeForArrangedSubviews
{
	BOOL isVerticalAxis = UILayoutConstraintAxisIsVertical(self.axis);
	NSInteger visibleCount = 0;
	CGFloat width = 0.0, height = 0.0;
	for ( UIView *view in self.arrangedSubviews ) {
		if ( view.isHidden ) continue;

		++visibleCount;
		
		CGSize viewSize = [view intrinsicContentSize];
		if ( isVerticalAxis ) {
			// calculate height, width is max of all arranged views
			width = MAX(width,viewSize.width);
			height += viewSize.height;
		}
		else {
			// calculate width, height is max of all arranged views
			width += viewSize.width;
			height = MAX(height, viewSize.height);
		}
	}

	CGFloat spacing = (visibleCount > 0) ? (visibleCount-1) * self.spacing : 0.0;
	if ( isVerticalAxis ){
		height += spacing;
	}
	else {
		width += spacing;
	}

	CGSize size = (CGSize){width,height};
	
	return size;
}

- (void)addArrangedSubview:(UIView *)subview
{
	if ( ![self.arrangedSubviews containsObject:subview] ) {
		self.arrangedSubviews = [self.arrangedSubviews arrayByAddingObject:subview];
		[self addSubview:subview];
		[subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:NULL];
#if _DEBUG_
		NSInteger addr = (NSInteger)subview;
		CGFloat hue = (addr & 0x0000000ff)/256.0;
		subview.layer.borderColor = [[UIColor colorWithHue:hue
												saturation:1.0 brightness:1.0 alpha:1.0] CGColor];
		subview.layer.borderWidth = 1.0;
#endif
		[self setNeedsUpdateConstraints];
	}
}

- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index
{
	if ( ![self.arrangedSubviews containsObject:subview] ) {
		self.arrangedSubviews = [self.arrangedSubviews arrayByAddingObject:subview];
		[subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:NULL];
#if _DEBUG_
		NSInteger addr = (NSInteger)subview;
		CGFloat hue = (addr & 0x0000000ff)/256.0;
		subview.layer.borderColor = [[UIColor colorWithHue:hue
												saturation:1.0 brightness:1.0 alpha:1.0] CGColor];
		subview.layer.borderWidth = 1.0;
#endif
		[self insertSubview:subview atIndex:index];
		[self setNeedsUpdateConstraints];
	}
}

- (void)removeArrangedSubview:(UIView *)subview
{
	NSMutableArray * subviews = [self.arrangedSubviews mutableCopy];
	[subviews removeObject:subview];
	self.arrangedSubviews = subviews;
	[subview removeObserver:subview forKeyPath:@"hidden"];
}

- (void)setAxis:(UILayoutConstraintAxis)axis
{
	[self willChangeValueForKey:@"axis"];
	if ( _axis != axis ) {
		_axis = axis;
		[self setNeedsUpdateConstraints];
	}
	[self didChangeValueForKey:@"axis"];
}
#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"hidden"] ) {
		[self setNeedsUpdateConstraints];
	}
}
@end
