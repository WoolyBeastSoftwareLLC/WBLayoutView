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

- (CGSize)calculateMinimumViewSize;
- (NSArray *)constraintsForView:(UIView *)view relativeToPreviousView:(UIView *)previousView;
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

- (void)updateConstraints
{
	[super updateConstraints];
	
	// calculate new constraints...
	NSMutableArray *constraints = [NSMutableArray new];
	NSArray *views = self.arrangedSubviews;
	UIView *previousView = nil;
	for ( UIView *view in views ) {
		if ( !view.isHidden) {
			NSArray *viewConstraints = [self constraintsForView:view relativeToPreviousView:previousView];
			[constraints addObjectsFromArray:viewConstraints];
			previousView = view;
		}
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
	CGFloat spacing = (previousView) ? self.spacing : 0.0;
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

	[constraints addObjectsFromArray:@[[viewAnchor constraintEqualToAnchor:previousViewAnchor constant:spacing],
									   [[view anchorForLayoutAttribute:layoutAttribute] constraintEqualToAnchor:[self anchorForLayoutAttribute:layoutAttribute]]]];
	
	return constraints;
}

#pragma mark -

- (CGSize)calculateMinimumViewSize
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
