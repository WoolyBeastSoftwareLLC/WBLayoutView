//
//  WBLayoutView.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBLayoutViewAlignment) {
	WBLayoutViewAlignmentFill = 0,
	WBLayoutViewAlignmentLeading,
	WBLayoutViewAlignmentTop = WBLayoutViewAlignmentLeading,
	WBLayoutViewAlignmentTrailing,
	WBLayoutViewAlignmentBottom = WBLayoutViewAlignmentTrailing,
	WBLayoutViewAlignmentCenter,
};

typedef NS_ENUM(NSInteger, WBLayoutViewDistribution) {
	WBLayoutViewDistributionFill = 0,
	WBLayoutViewDistributionFillEqually,
	WBLayoutViewDistributionFillProportionally,
	WBLayoutViewDistributionEqualSpacing,
	WBLayoutViewDistributionEqualCentering
};

@interface WBLayoutView : UIView
@property (nonatomic) WBLayoutViewAlignment		alignment;
@property (nonatomic) UILayoutConstraintAxis		axis;
@property (nonatomic) WBLayoutViewDistribution	distribution;
@property (nonatomic) CGFloat					spacing;

@property (nonatomic,copy) NSArray *arrangedSubviews;
- (void)addArrangedSubview:(UIView *)subview;
- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index;
- (void)removeArrangedSubview:(UIView *)subview;

- (CGSize)minimumSizeForArrangedSubviews;
@end
