//
//  ViewController.m
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/21.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ViewController.h"
#import "YZXLineChartView.h"

@interface ViewController ()

@property (nonatomic, strong) YZXLineChartView                    *lineChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.lineChartView.titleArr = @[@"title1title1title1title1",@"title2",@"title3",@"title4",@"title5"];
    self.lineChartView.contentArr = @[@"100000",@"105000",@"60000",@"65000",@"25600"];
    self.lineChartView.maxScaleValue = 160000.0;
    self.lineChartView.calibrationIntervalValue = 10000.0;
    [self.view addSubview:self.lineChartView];
}

#pragma mark - 初始化
- (YZXLineChartView *)lineChartView
{
    if (!_lineChartView) {
        _lineChartView = [[YZXLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _lineChartView.center = self.view.center;
        _lineChartView.backgroundColor = [UIColor greenColor];
    }
    return _lineChartView;
}

@end
