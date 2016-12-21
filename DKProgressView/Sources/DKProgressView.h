//
//  DKProgressView.h
//  DKProgressView
//
//  Created by xuli on 2016/12/20.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DKProgressType) {
    DKProgressTypeOnlyCircle,/**< 创建只有圆圈的进度图*/
    DKProgressTypeWithTextBelow/**< 创建圆圈并且圆圈下方有文字的进度图*/
};

@interface DKProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame progressType:(DKProgressType)type totalNumber:(int)totalNumber completedNumber:(int)completedNumber;

/**
 *  创建一个只有圆圈，没有文字的进度图
 */
- (instancetype)initWithFrame:(CGRect)frame totalNumber:(int)totalNumber completedNumber:(int)completedNumber;

@property (nonatomic, strong) UIColor *dk_CompletedFilledColor;

@property (nonatomic, assign) int dk_CircleTotalNumber;

@property (nonatomic, assign) int dk_CircleCompletedNumber;

@property (nonatomic, assign) CGFloat dk_lineWidth;

@property (nonatomic, readonly) CGFloat dk_animationDuration;

@property (nonatomic, copy) NSArray *dk_arrayTitles;/**< 当进度图类型为DKProgressTypeWithTextBelow时需要设置的参数，如果为空，将显示默认文字（步骤1，步骤2。。。）*/

- (void)moveToCircle:(int)completedNumber animated:(BOOL)animated;
@end
