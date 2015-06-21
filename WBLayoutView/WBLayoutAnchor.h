//
//  WBLayoutAnchor.h
//  WBLayoutView
//
//  Created by Scott Chandler on 6/19/15.
//  Copyright (c) 2015 Wooly Beast Software LLC. All rights reserved.
//

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