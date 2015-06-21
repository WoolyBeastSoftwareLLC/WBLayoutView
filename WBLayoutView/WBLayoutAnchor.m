//
//  WBLayoutAnchor.m
//  WBLayoutView
//
//  Created by Scott Chandler on 6/19/15.
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

#import "WBLayoutAnchor.h"

@interface WBLayoutAnchor()
@property (nonatomic,weak) UIView *view;
@property (nonatomic) NSLayoutAttribute attribute;

- (instancetype)initWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;
- (BOOL)isCompatibleWithAnchor:(WBLayoutAnchor *)anchor;
@end

@implementation WBLayoutAnchor
- (instancetype)initWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
	if ( self = [super init], self ) {
		_view = view;
		_attribute = attribute;
	}
	return self;
}

- (BOOL)isCompatibleWithAnchor:(WBLayoutAnchor *)anchor
{
	return [self isKindOfClass:[anchor class]];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutAnchor *)anchor
{
	return [self constraintEqualToAnchor:anchor constant:0.0];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutAnchor *)anchor constant:(CGFloat)constant
{
	NSParameterAssert([anchor isCompatibleWithAnchor:self]);
	if ( ![anchor isCompatibleWithAnchor:self] ) {
		return nil;
	}
	else {
		return [NSLayoutConstraint constraintWithItem:self.view
											attribute:self.attribute
											relatedBy:NSLayoutRelationEqual
											   toItem:anchor.view
											attribute:anchor.attribute
										   multiplier:1.0 constant:constant];
	}
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutAnchor *)anchor
{
	return [self constraintLessThanOrEqualToAnchor:anchor constant:0.0];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutAnchor *)anchor constant:(CGFloat)constant
{
	NSParameterAssert([anchor isCompatibleWithAnchor:self]);
	if ( ![anchor isCompatibleWithAnchor:self] ) {
		return nil;
	}
	else {
		return [NSLayoutConstraint constraintWithItem:self.view
											attribute:self.attribute
											relatedBy:NSLayoutRelationLessThanOrEqual
											   toItem:anchor.view
											attribute:anchor.attribute
										   multiplier:1.0 constant:constant];
	}
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutAnchor *)anchor
{
	return [self constraintGreaterThanOrEqualToAnchor:anchor constant:0.0];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutAnchor *)anchor constant:(CGFloat)constant
{
	NSParameterAssert([anchor isCompatibleWithAnchor:self]);
	if ( ![anchor isCompatibleWithAnchor:self] ) {
		return nil;
	}
	else {
		return [NSLayoutConstraint constraintWithItem:self.view
											attribute:self.attribute
											relatedBy:NSLayoutRelationGreaterThanOrEqual
											   toItem:anchor.view
											attribute:anchor.attribute
										   multiplier:1.0 constant:constant];
	}
}

@end

#pragma mark -

@implementation WBLayoutAxisXAnchor
@end

#pragma mark -

@implementation WBLayoutAxisYAnchor
@end

#pragma mark -

@implementation WBLayoutDimension
- (NSLayoutConstraint *)constraintEqualToConstant:(CGFloat)constant
{
	return [NSLayoutConstraint constraintWithItem:self.view
										attribute:self.attribute
										relatedBy:NSLayoutRelationEqual
										   toItem:nil
										attribute:NSLayoutAttributeNotAnAttribute
									   multiplier:1.0 constant:constant];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier
{
	return [self constraintEqualToAnchor:anchor multiplier:multiplier constant:0.0];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
	NSParameterAssert([anchor isCompatibleWithAnchor:self]);
	if ( ![anchor isCompatibleWithAnchor:self] ) {
		return nil;
	}
	else {
		return [NSLayoutConstraint constraintWithItem:self.view
											attribute:self.attribute
											relatedBy:NSLayoutRelationEqual
											   toItem:anchor.view
											attribute:anchor.attribute
										   multiplier:multiplier constant:constant];
	}
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier
{
	return [self constraintLessThanOrEqualToAnchor:anchor multiplier:multiplier constant:0.0];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
	NSParameterAssert([anchor isCompatibleWithAnchor:self]);
	if ( ![anchor isCompatibleWithAnchor:self] ) {
		return nil;
	}
	else {
		return [NSLayoutConstraint constraintWithItem:self.view
											attribute:self.attribute
											relatedBy:NSLayoutRelationLessThanOrEqual
											   toItem:anchor.view
											attribute:anchor.attribute
										   multiplier:multiplier constant:constant];
	}
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier
{
	return [self constraintGreaterThanOrEqualToAnchor:anchor multiplier:multiplier constant:0.0];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
	NSParameterAssert([anchor isCompatibleWithAnchor:self]);
	if ( ![anchor isCompatibleWithAnchor:self] ) {
		return nil;
	}
	else {
		return [NSLayoutConstraint constraintWithItem:self.view
											attribute:self.attribute
											relatedBy:NSLayoutRelationGreaterThanOrEqual
											   toItem:anchor.view
											attribute:anchor.attribute
										   multiplier:multiplier constant:constant];
	}
}
@end

#pragma mark -

@implementation  UIView(WBLayoutAnchor)
- (WBLayoutAxisXAnchor *)leftAnchor		{ return [[WBLayoutAxisXAnchor alloc] initWithView:self attribute:NSLayoutAttributeLeft]; }
- (WBLayoutAxisXAnchor *)rightAnchor		{ return [[WBLayoutAxisXAnchor alloc] initWithView:self attribute:NSLayoutAttributeRight]; }
- (WBLayoutAxisYAnchor *)topAnchor		{ return [[WBLayoutAxisYAnchor alloc] initWithView:self attribute:NSLayoutAttributeTop]; }
- (WBLayoutAxisYAnchor *)bottomAnchor	{ return [[WBLayoutAxisYAnchor alloc] initWithView:self attribute:NSLayoutAttributeBottom]; }
- (WBLayoutAxisXAnchor *)leadingAnchor	{ return [[WBLayoutAxisXAnchor alloc] initWithView:self attribute:NSLayoutAttributeLeading]; }
- (WBLayoutAxisXAnchor *)trailingAnchor	{ return [[WBLayoutAxisXAnchor alloc] initWithView:self attribute:NSLayoutAttributeTrailing]; }
- (WBLayoutAxisXAnchor *)centerXAnchor	{ return [[WBLayoutAxisXAnchor alloc] initWithView:self attribute:NSLayoutAttributeCenterX]; }
- (WBLayoutAxisYAnchor *)centerYAnchor	{ return [[WBLayoutAxisYAnchor alloc] initWithView:self attribute:NSLayoutAttributeCenterY]; }
- (WBLayoutDimension *)widthAnchor		{ return [[WBLayoutDimension alloc] initWithView:self attribute:NSLayoutAttributeWidth]; }
- (WBLayoutDimension *)heightAnchor		{ return [[WBLayoutDimension alloc] initWithView:self attribute:NSLayoutAttributeHeight]; }
- (WBLayoutAnchor *)anchorForLayoutAttribute:(NSLayoutAttribute)attribute
{
	WBLayoutAnchor *anchor = nil;
	switch (attribute) {
		case NSLayoutAttributeTop		: anchor = self.topAnchor;		break;
		case NSLayoutAttributeBottom		: anchor = self.bottomAnchor;	break;
		case NSLayoutAttributeLeft		: anchor = self.leftAnchor;		break;
		case NSLayoutAttributeRight		: anchor = self.rightAnchor;		break;
		case NSLayoutAttributeLeading	: anchor = self.leadingAnchor;	break;
		case NSLayoutAttributeTrailing	: anchor = self.trailingAnchor;	break;
		case NSLayoutAttributeCenterX	: anchor = self.centerXAnchor;	break;
		case NSLayoutAttributeCenterY	: anchor = self.centerYAnchor;	break;
		case NSLayoutAttributeHeight		: anchor = self.heightAnchor;	break;
		case NSLayoutAttributeWidth		: anchor = self.widthAnchor;		break;
	}
	return anchor;
}
@end