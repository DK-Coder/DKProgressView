//
//  ViewController.m
//  DKProgressView
//
//  Created by xuli on 2016/12/20.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import "ViewController.h"
#import "DKProgressView.h"

@interface ViewController ()
{
    NSMutableArray *arrayProgressViews;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self addButtonArea];
    [self resetProgressView];
    [self addAnimation];
}

- (void)addButtonArea
{
    UIView *buttonArea = [[UIView alloc] initWithFrame:CGRectMake(0.f, 64.f, self.view.frame.size.width, 60.f)];
    buttonArea.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonArea];
    
    CGFloat widthForButton = (self.view.frame.size.width - 30.f) / 2.f;
    UIButton *btnReset = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 10.f, widthForButton, 40.f)];
    [btnReset setTitle:@"重置控件" forState:UIControlStateNormal];
    [btnReset setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnReset.layer setCornerRadius:10.f];
    [btnReset.layer setBorderWidth:2.f];
    [btnReset.layer setBorderColor:[UIColor orangeColor].CGColor];
    [btnReset addTarget:self action:@selector(resetProgressView) forControlEvents:UIControlEventTouchUpInside];
    [buttonArea addSubview:btnReset];
    
    UIButton *btnStart = [[UIButton alloc] initWithFrame:CGRectMake(20.f + widthForButton, 10.f, widthForButton, 40.f)];
    [btnStart setTitle:@"开始动画" forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnStart.layer setCornerRadius:10.f];
    [btnStart.layer setBorderWidth:2.f];
    [btnStart.layer setBorderColor:[UIColor orangeColor].CGColor];
    [btnStart addTarget:self action:@selector(addAnimation) forControlEvents:UIControlEventTouchUpInside];
    [buttonArea addSubview:btnStart];
}

- (void)resetProgressView
{
    if (!arrayProgressViews) {
        arrayProgressViews = [[NSMutableArray alloc] init];
    } else {
        [arrayProgressViews removeAllObjects];
    }
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[DKProgressView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < 4; i++) {
        CGRect frame = CGRectMake(0.f, 64.f + 60.f * (i + 1) + 10.f, self.view.frame.size.width, 60.f);
        DKProgressView *progressView = [[DKProgressView alloc] initWithFrame:frame totalNumber:i + 5 completedNumber:i + 1];
        [arrayProgressViews addObject:progressView];
        [self.view addSubview:progressView];
    }
    
    for (int i = 0; i < 4; i++) {
        CGRect frame = CGRectMake(0.f, 64.f + 60.f * 4 + 10.f * 2 + 60.f * (i + 1), self.view.frame.size.width, 60.f);
        DKProgressView *progressView = [[DKProgressView alloc] initWithFrame:frame progressType:DKProgressTypeWithTextBelow totalNumber:i + 3 completedNumber:i];
        [arrayProgressViews addObject:progressView];
        [self.view addSubview:progressView];
    }
}

- (void)addAnimation
{
    for (DKProgressView *progressView in arrayProgressViews) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [progressView moveToCircle:progressView.dk_CircleCompletedNumber + 2 animated:progressView.dk_CircleCompletedNumber % 2 == 0];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
