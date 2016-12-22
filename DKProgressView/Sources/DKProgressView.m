//
//  DKProgressView.m
//  DKProgressView
//
//  Created by xuli on 2016/12/20.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import "DKProgressView.h"
#import "UIImage+DKExtension.h"

@interface DKProgressView()
{
    DKProgressType progressType;
    
    CGFloat widthForCircle;
    CGFloat widthForLine;
    
    NSMutableArray *arrayCircles;
    NSMutableArray *arrayLines;
    NSMutableArray *arrayTextLayers;
    
    UIColor *toDoFilledColor;/**< 未完成的圆圈背景色*/
}
@end

@implementation DKProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame progressType:(DKProgressType)type totalNumber:(int)totalNumber completedNumber:(int)completedNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
        
        progressType = type;
        _dk_CircleTotalNumber = totalNumber;
        _dk_CircleCompletedNumber = completedNumber;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame totalNumber:(int)totalNumber completedNumber:(int)completedNumber
{
    return [self initWithFrame:frame progressType:DKProgressTypeOnlyCircle totalNumber:totalNumber completedNumber:completedNumber];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 一般圆圈最多8个
    _dk_CircleTotalNumber = _dk_CircleTotalNumber < 8 ? _dk_CircleTotalNumber : 8;
    // 完成数量最少1个，不能0个
    _dk_CircleCompletedNumber = _dk_CircleCompletedNumber < 1 ? 1 : _dk_CircleCompletedNumber;
    // 圆圈的直径，取视图宽度和高度的最小值然后减去上下间隔20
    widthForCircle = MIN(self.frame.size.width, self.frame.size.height) - 20.f;
    // 根据圆圈的直径和视图的宽度计算中间线段的长度
    widthForLine = (self.frame.size.width - 20.f - _dk_CircleTotalNumber * widthForCircle) / (_dk_CircleTotalNumber - 1);
    switch (progressType) {
        case DKProgressTypeOnlyCircle:
            [self initializeOnlyCircle];
            break;
        case DKProgressTypeWithTextBelow:
            [self initializeWithTextBelow];
            break;
        default:
            break;
    }
}

- (void)sharedInit
{
    self.backgroundColor = [UIColor whiteColor];
    
    progressType = DKProgressTypeOnlyCircle;
    _dk_CompletedFilledColor = [UIColor redColor];
    _dk_CircleTotalNumber = 3;
    _dk_CircleCompletedNumber = 2;
    _dk_lineWidth = 8.f;
    
    arrayCircles = [[NSMutableArray alloc] init];
    arrayLines = [[NSMutableArray alloc] init];
    
    toDoFilledColor = [UIColor colorWithRed:204.f / 255.f green:204.f / 255.f blue:204.f / 255.f alpha:1.f];
}

- (void)initializeOnlyCircle
{
    for (int i = 0; i < _dk_CircleTotalNumber; i++) {
        CALayer *circleLayer = [CALayer layer];
        if (i < _dk_CircleCompletedNumber) {
            // 添加已完成的圆圈
            circleLayer.contents = (id)[[UIImage imageNamed:@"Resources.bundle/OK_Filled.png"] changeColorTo:_dk_CompletedFilledColor].CGImage;
        } else {
            // 添加未完成的圆圈
            circleLayer.contents = (id)[UIImage imageNamed:@"Resources.bundle/OK_Filled.png"].CGImage;
        }
        circleLayer.frame = CGRectMake(10.f + (widthForCircle + widthForLine - 2.f) * i, 10.f, widthForCircle, widthForCircle);
        circleLayer.masksToBounds = YES;
        [arrayCircles addObject:circleLayer];
        [self.layer addSublayer:circleLayer];
        // 添加线段
        if (i != _dk_CircleTotalNumber - 1) {
            BOOL isCompleted = _dk_CircleCompletedNumber - i > 1 ? YES : NO;
            CAShapeLayer *grayLineLayer = [self generateLineLayerNextToLayer:circleLayer isCompleted:NO];
            CAShapeLayer *lineLayer = [self generateLineLayerNextToLayer:circleLayer isCompleted:isCompleted];
            [arrayLines addObject:grayLineLayer];
            [arrayLines addObject:lineLayer];
            [self.layer insertSublayer:lineLayer below:circleLayer];
            [self.layer insertSublayer:grayLineLayer below:lineLayer];
        }
    }
}

- (void)initializeWithTextBelow
{
    if (!_dk_arrayTitles) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < _dk_CircleTotalNumber; i++) {
            [array addObject:[NSString stringWithFormat:@"步骤%d", i + 1]];
        }
        _dk_arrayTitles = [array mutableCopy];
    }
    
    NSAssert(_dk_arrayTitles.count == _dk_CircleTotalNumber, @"所提供下方文字的个数与圆圈总个数不相同，请检查后继续！");
    
    arrayTextLayers = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dk_CircleTotalNumber; i++) {
        CALayer *circleLayer = [CALayer layer];
        if (i < _dk_CircleCompletedNumber) {
            // 添加已完成的圆圈
            circleLayer.contents = (id)[[UIImage imageNamed:@"Resources.bundle/OK_Filled.png"] changeColorTo:_dk_CompletedFilledColor].CGImage;
        } else {
            // 添加未完成的圆圈
            circleLayer.contents = (id)[UIImage imageNamed:@"Resources.bundle/OK_Filled.png"].CGImage;
        }
        circleLayer.frame = CGRectMake(10.f + (widthForCircle + widthForLine - 2.f) * i, 0.f, widthForCircle, widthForCircle);
        circleLayer.masksToBounds = YES;
        [arrayCircles addObject:circleLayer];
        [self.layer addSublayer:circleLayer];
        // 添加线段
        if (i != _dk_CircleTotalNumber - 1) {
            BOOL isCompleted = _dk_CircleCompletedNumber - i > 1 ? YES : NO;
            CAShapeLayer *grayLineLayer = [self generateLineLayerNextToLayer:circleLayer isCompleted:NO];
            CAShapeLayer *lineLayer = [self generateLineLayerNextToLayer:circleLayer isCompleted:isCompleted];
            [arrayLines addObject:grayLineLayer];
            [arrayLines addObject:lineLayer];
            [self.layer insertSublayer:lineLayer below:circleLayer];
            [self.layer insertSublayer:grayLineLayer below:lineLayer];
        }
        // 添加文字图层
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(circleLayer.frame.origin.x, self.frame.size.height - 20.f, circleLayer.frame.size.width, 20.f);
        textLayer.string = _dk_arrayTitles[i];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = i < _dk_CircleCompletedNumber ? _dk_CompletedFilledColor.CGColor : toDoFilledColor.CGColor;
        textLayer.fontSize = 14.f;
        textLayer.alignmentMode = kCAAlignmentCenter;
        [arrayTextLayers addObject:textLayer];
        [self.layer addSublayer:textLayer];
    }
}

- (void)moveToCircle:(int)completedNumber animated:(BOOL)animated
{
    // 完成的数量必须小于总数量，并且完成的数量不能等于已经完成的数量
    // 如果总体有8个，完成有9个，则不进行操作
    // 如果完成有8个，需要完成到第8个，那么也不进行操作，因为本身就已经完成了8个。没有变化
    if (completedNumber <= _dk_CircleTotalNumber && completedNumber != _dk_CircleCompletedNumber) {
        if (completedNumber > _dk_CircleCompletedNumber) {
            if (animated) {
                for (int i = 0, length = completedNumber - _dk_CircleCompletedNumber; i < length; i++) {
                    // 获取某个圆形的图层
                    CALayer *circleLayer = arrayCircles[i + _dk_CircleCompletedNumber];
                    // 获取某个线段的图层
                    CAShapeLayer *lineLayer = arrayLines[(i + _dk_CircleCompletedNumber) * 2 - 1];
                    lineLayer.strokeColor = _dk_CompletedFilledColor.CGColor;
                    // 为线段添加动画，从左到右
                    CABasicAnimation *lineShowAnimation = [self generateStrokeEndAnimation];
                    [lineLayer addAnimation:lineShowAnimation forKey:nil];
                    // 为圆圈添加动画
                    CABasicAnimation *circleContentsAnimation = [self generateContentsAnimationBasedOn:lineShowAnimation];
                    [circleLayer addAnimation:circleContentsAnimation forKey:nil];
                    if (progressType == DKProgressTypeWithTextBelow) {
                        CATextLayer *textLayer = arrayTextLayers[i + _dk_CircleCompletedNumber];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lineShowAnimation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            textLayer.foregroundColor = _dk_CompletedFilledColor.CGColor;
                        });
                        // 不知道为何这个keypath无效，不会变换颜色。所以换了另外一种。如果不用设置延迟时间的话，直接设置foregroundColor属性即可
//                        CABasicAnimation *changeColorAnimation = [CABasicAnimation animationWithKeyPath:@"foregroundColor"];
////                        changeColorAnimation.fromValue = (id)toDoFilledColor.CGColor;
//                        changeColorAnimation.toValue = (id)_dk_CompletedFilledColor.CGColor;
//                        changeColorAnimation.beginTime = lineShowAnimation.duration + CACurrentMediaTime();
//                        changeColorAnimation.duration = circleContentsAnimation.duration;
//                        changeColorAnimation.fillMode = kCAFillModeForwards;
//                        changeColorAnimation.removedOnCompletion = NO;
//                        [textLayer addAnimation:changeColorAnimation forKey:nil];
                    }
                }
            } else {
                // 将需要填充的小球进行填充，以及线段进行填色
                for (int i = 0, length = completedNumber - _dk_CircleCompletedNumber; i < length; i++) {
                    // 获取某个圆形的图层
                    CALayer *circleLayer = arrayCircles[i + _dk_CircleCompletedNumber];
                    // 直接设置图层的content更改其内容
                    circleLayer.contents = (id)[[UIImage imageNamed:@"Resources.bundle/OK_Filled.png"] changeColorTo:_dk_CompletedFilledColor].CGImage;
                    // 获取某个线段的图层
                    CAShapeLayer *lineLayer = arrayLines[(i + _dk_CircleCompletedNumber) * 2 - 1];
                    // 直接设置线段颜色
                    lineLayer.strokeColor = _dk_CompletedFilledColor.CGColor;
                    // 获取文字图层
                    if (progressType == DKProgressTypeWithTextBelow) {
                        CATextLayer *textLayer = arrayTextLayers[i + _dk_CircleCompletedNumber];
                        textLayer.foregroundColor = _dk_CompletedFilledColor.CGColor;
                    }
                }
            }
        }
    }
    
    _dk_CircleCompletedNumber = completedNumber;
}

- (CAShapeLayer *)generateLineLayerNextToLayer:(CALayer *)layer isCompleted:(BOOL)isCompleted
{
    UIBezierPath *pathLine = [UIBezierPath bezierPath];
    [pathLine moveToPoint:CGPointMake(layer.frame.origin.x + layer.frame.size.width - 2.f, layer.position.y)];
    [pathLine addLineToPoint:CGPointMake(layer.frame.origin.x + layer.frame.size.width + widthForLine, layer.position.y)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = pathLine.CGPath;
    lineLayer.lineWidth = _dk_lineWidth;
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinRound;
    lineLayer.strokeColor = isCompleted ? _dk_CompletedFilledColor.CGColor : toDoFilledColor.CGColor;
    lineLayer.strokeStart = 0.f;
    lineLayer.strokeEnd = 1.f;
    
    return lineLayer;
}

- (CABasicAnimation *)generateStrokeEndAnimation
{
    CABasicAnimation *lineShowAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    lineShowAnimation.fromValue = @(0.f);
    lineShowAnimation.toValue = @(1.f);
    lineShowAnimation.duration = .4f;
    lineShowAnimation.fillMode = kCAFillModeForwards;
    lineShowAnimation.removedOnCompletion = NO;
    
    return lineShowAnimation;
}

- (CABasicAnimation *)generateContentsAnimationBasedOn:(CABasicAnimation *)strokeEndAnimation
{
    CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    contentsAnimation.toValue = (id)[[UIImage imageNamed:@"Resources.bundle/OK_Filled.png"] changeColorTo:_dk_CompletedFilledColor].CGImage;
    contentsAnimation.beginTime = strokeEndAnimation.duration + CACurrentMediaTime();
    contentsAnimation.duration = strokeEndAnimation.duration;
    contentsAnimation.fillMode = kCAFillModeForwards;
    contentsAnimation.removedOnCompletion = NO;
    
    return contentsAnimation;
}

- (CGFloat)dk_animationDuration
{
    return .8f;
}
@end
