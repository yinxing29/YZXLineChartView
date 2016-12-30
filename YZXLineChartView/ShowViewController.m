//
//  ShowViewController.m
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/22.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ShowViewController.h"
#import "YZXLineChartView.h"

@interface ShowViewController ()

@property (nonatomic, strong) YZXLineChartView                    *lineChartView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"折线图";
    self.view.backgroundColor = [UIColor whiteColor];
    self.lineChartView.titleArr = self.titleArr;
    self.lineChartView.contentArr = self.contentArr;
    self.lineChartView.maxScaleValue = self.maxScaleValue;
    self.lineChartView.calibrationIntervalValue = self.calibrationIntervalValue;
    self.lineChartView.lineColor = self.lineColor;
    self.lineChartView.coordinateColor = self.coordinateColor;
    if (self.coordinateContentFont != 0) {
        self.lineChartView.coordinateContentFont = self.coordinateContentFont;
    }
    if (self.annotationTitleFont != 0) {
        self.lineChartView.annotationTitleFont = self.annotationTitleFont;
    }
    self.lineChartView.hideAnnotation = self.hideAnnotation;
    self.lineChartView.annotatinColor = self.annotatinColor;
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
