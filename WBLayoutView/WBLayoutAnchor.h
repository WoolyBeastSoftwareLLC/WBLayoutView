//
//  WBLayoutAnchor.h
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

#import <UIKit/UIKit.h>

@interface WBLayoutAnchor : NSObject
- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutAnchor *)anchor;
- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutAnchor *)anchor constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutAnchor *)anchor;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutAnchor *)anchor constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutAnchor *)anchor;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutAnchor *)anchor constant:(CGFloat)constant;
@end

@interface WBLayoutAxisXAnchor : WBLayoutAnchor
@end

@interface WBLayoutAxisYAnchor : WBLayoutAnchor
@end

@interface WBLayoutDimension : WBLayoutAnchor
- (NSLayoutConstraint *)constraintEqualToConstant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint *)constraintEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(WBLayoutDimension *)anchor multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
@end


@interface UIView(WBLayoutAnchor)
- (WBLayoutAxisXAnchor *)leftAnchor;
- (WBLayoutAxisXAnchor *)rightAnchor;
- (WBLayoutAxisYAnchor *)topAnchor;
- (WBLayoutAxisYAnchor *)bottomAnchor;
- (WBLayoutAxisXAnchor *)leadingAnchor;
- (WBLayoutAxisXAnchor *)trailingAnchor;
- (WBLayoutAxisXAnchor *)centerXAnchor;
- (WBLayoutAxisYAnchor *)centerYAnchor;
- (WBLayoutDimension *)widthAnchor;
- (WBLayoutDimension *)heightAnchor;

- (WBLayoutAnchor *)anchorForLayoutAttribute:(NSLayoutAttribute)attribute;
@end