//
//  WBLayoutView.h
//  WBLayoutView
//
//  Created by Scott Chandler on 6/15/15.
//  Copyright (c) 2015 Wooly Beast Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBLayoutViewAlignment) {
	WBLayoutViewAlignmentFill,
	WBLayoutViewAlignmentLeading,
	WBLayoutViewAlignmentTop = WBLayoutViewAlignmentLeading,
	WBLayoutViewAlignmentTrailing,
	WBLayoutViewAlignmentBottom = WBLayoutViewAlignmentTrailing,
	WBLayoutViewAlignmentCenter,
};

// future work
typedef NS_ENUM(NSInteger, WBLayoutViewDistribution) {
	WBLayoutViewDistributionEqualSpacing
};

@interface WBLayoutView : UIView
@property (nonatomic) UILayoutConstraintAxis axis;
@property (nonatomic) WBLayoutViewAlignment alignment;
@property (nonatomic) WBLayoutViewDistribution distribution;
@property (nonatomic) CGFloat spacing;

@property (nonatomic,copy) NSArray *arrangedSubviews;
- (void)addArrangedSubview:(UIView *)subview;
- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index;
- (void)removeArrangedSubview:(UIView *)subview;
@end
