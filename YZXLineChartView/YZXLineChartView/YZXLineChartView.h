//
//  YZXLineChartView.h
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/21.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZXLineChartView : UIView

/**
 标题
 */
@property (nonatomic, strong) NSArray                    *titleArr;

/**
 内容
 */
@property (nonatomic, strong) NSArray                    *contentArr;

/**
 折现颜色
 */
@property (nonatomic, strong) UIColor                    *lineColor;

/**
 坐标颜色
 */
@property (nonatomic, strong) UIColor                    *coordinateColor;

/**
 Y轴最大刻度
 */
@property (nonatomic, assign) CGFloat                    maxScaleValue;

/**
 Y轴刻度间隔值
 */
@property (nonatomic, assign) CGFloat                    calibrationIntervalValue;

/**
 注释的字体颜色
 */
@property (nonatomic, strong) UIColor                    *annotatinColor;

/**
 坐标系内容字体大小(默认为10.0)
 */
@property (nonatomic, assign) CGFloat                    coordinateContentFont;

/**
 是否隐藏标注
 */
@property (nonatomic, assign) BOOL                       hideAnnotation;

/**
 注释字体大小(默认为10.0)
 */
@property (nonatomic, assign) CGFloat                    annotationTitleFont;

@end
