//
//  UIImage+DKExtension.h
//  DKAnimationDemo
//
//  Created by xuli on 2016/12/19.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DKExtension)

/**
 *  将图片变换颜色，比较适用于大面积的纯色图片或者纯色图片。该方法会触发离屏渲染，慎用！
 */
- (UIImage *)changeColorTo:(UIColor *)color;
@end
