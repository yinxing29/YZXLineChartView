//
//  YZXLineChartView.m
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/21.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "YZXLineChartView.h"

//原点坐标
#define origin_x 30.0
#define origin_y self.bounds.size.height - 30.0

//X轴终点坐标x,y
#define X_X self.bounds.size.width - 20.0
#define X_Y origin_y

//Y轴终点坐标x,y
#define Y_X origin_x
#define Y_Y 60.0

@implementation YZXLineChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coordinateColor = [UIColor blackColor];
        self.lineColor = [UIColor blackColor];
        
        self.maxScaleValue = 100.0;
        self.calibrationIntervalValue = 10.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.titleArr.count != self.contentArr.count) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"所传入数据数量不同，无法对应" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
    //坐标原点
    CGContextMoveToPoint(context, origin_x, origin_y);
    //X轴
    CGContextAddLineToPoint(context, X_X, X_Y);
    //添加X轴
    CGContextDrawPath(context, kCGPathStroke);
    //画X轴箭头
    CGContextSetFillColorWithColor(context, self.coordinateColor.CGColor);
    CGPoint points[3];
    points[0] = CGPointMake(X_X, origin_y + 3.0);
    points[1] = CGPointMake(X_X + 6.0, X_Y);
    points[2] = CGPointMake(X_X, origin_y - 3.0);
    CGContextAddLines(context, points, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    //坐标原点
    CGContextMoveToPoint(context, origin_x, origin_y);
    //Y轴
    CGContextAddLineToPoint(context, Y_X, Y_Y);
    //添加Y轴
    CGContextDrawPath(context, kCGPathStroke);
    //画Y轴箭头
    CGContextSetFillColorWithColor(context, self.coordinateColor.CGColor);
    CGPoint YPoints[3];
    YPoints[0] = CGPointMake(origin_x, Y_Y - 6.0);
    YPoints[1] = CGPointMake(origin_x - 3.0, Y_Y);
    YPoints[2] = CGPointMake(origin_x + 3.0, Y_Y);
    CGContextAddLines(context, YPoints, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    //设置title字体大小
    UIFont *font = [UIFont systemFontOfSize:10.0];
    NSDictionary *arrts = @{NSFontAttributeName:font};
    //添加X轴大刻度
    CGFloat scale_x = (X_X - 10.0 - origin_x) / (float)self.titleArr.count;
    CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
    for (int i = 1; i<=self.titleArr.count; i++) {
        CGContextMoveToPoint(context, scale_x * i + origin_x, origin_y);
        CGContextAddLineToPoint(context, scale_x * i + origin_x, origin_y - 3.0);
        CGContextDrawPath(context, kCGPathStroke);
    
        //根据font计算一行文本的高度
        CGFloat onelineHeight = [self.titleArr[i - 1] boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size.height;

        CGSize titleSize = [self.titleArr[i - 1] boundingRectWithSize:CGSizeMake(self.bounds.size.height - (origin_y), onelineHeight * 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
        //添加X轴刻度说明
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scale_x * i + origin_x - titleSize.width / 2.0, origin_y + 10.0, self.bounds.size.height - (origin_y), titleSize.height)];
        label.text = self.titleArr[i - 1];
        label.textColor = self.coordinateColor;
        label.font = font;
        label.numberOfLines = 2;
        label.transform = CGAffineTransformMakeRotation(M_PI_4);
        [self addSubview:label];
    }
    
    //添加Y轴大刻度
    NSInteger scaleNumber = self.maxScaleValue / self.calibrationIntervalValue;
    //两个刻度之间的距离
    CGFloat scale_y = (origin_y - Y_Y - 10.0) / (float)scaleNumber;
    CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
    for (int i = 1; i<=scaleNumber; i++) {
        CGContextMoveToPoint(context, origin_x, origin_y - scale_y * i);
        CGContextAddLineToPoint(context, origin_x + 3.0, origin_y - scale_y * i);
        CGContextDrawPath(context, kCGPathStroke);
        
        NSString *scaleValue = [NSString stringWithFormat:@"%.0f",self.calibrationIntervalValue * i];
        if (self.calibrationIntervalValue * i >= 10000.0) {
            scaleValue = [NSString stringWithFormat:@"%.0f万",self.calibrationIntervalValue * i / 10000.0];
        }
        CGSize scaleValueSize = [scaleValue boundingRectWithSize:CGSizeMake(origin_x, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
        NSLog(@"%@",NSStringFromCGSize(scaleValueSize));
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentRight;
        //画刻度
        [scaleValue drawInRect:CGRectMake(0, origin_y - scale_y * i - scaleValueSize.height / 2.0, origin_x, scaleValueSize.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:self.coordinateColor,NSParagraphStyleAttributeName:paragraph}];
    }
    
    //添加内容
    __weak typeof(self) weak_self = self;
    __block CGPoint lastPoint = CGPointZero;
    [self.contentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat content_x = scale_x * (idx + 1) + origin_x;
        CGFloat content_scale = [obj floatValue] / (float)weak_self.maxScaleValue;
        CGFloat content_y = origin_y - scale_y * scaleNumber * content_scale;
        CGContextSetFillColorWithColor(context, weak_self.lineColor.CGColor);
        CGContextAddArc(context, content_x, content_y, 2, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathFill);
        //添加标注
        NSString *scaleValue = obj;
        if ([obj floatValue] >= 10000.0) {
            scaleValue = [NSString stringWithFormat:@"%.2f万",[obj floatValue] / 10000.0];
        }
        CGSize scaleValueSize = [scaleValue boundingRectWithSize:CGSizeMake(weak_self.bounds.size.width, weak_self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
        //画内容
        [scaleValue drawInRect:CGRectMake(content_x - scaleValueSize.width / 2.0, content_y - scaleValueSize.height - 2.0, scaleValueSize.width, scaleValueSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:self.coordinateColor}];
        //连线
        if (lastPoint.x != 0) {
            CGContextSetStrokeColorWithColor(context, weak_self.lineColor.CGColor);
            CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(context, content_x, content_y);
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        lastPoint.x = content_x;
        lastPoint.y = content_y;
    }];
}

#pragma mark - setter
- (void)setTitleArr:(NSArray *)titleArr
{
    if (_titleArr != titleArr) {
        _titleArr = titleArr;
    }
}

- (void)setContentArr:(NSArray *)contentArr
{
    if (_contentArr != contentArr) {
        _contentArr = contentArr;
    }
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
    }
}

- (void)setCoordinateColor:(UIColor *)coordinateColor
{
    if (_coordinateColor != coordinateColor) {
        _coordinateColor = coordinateColor;
    }
}

@end
