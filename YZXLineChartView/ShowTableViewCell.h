//
//  ShowTableViewCell.h
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/22.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContentBlock)(NSString *content, NSString *type);

@interface ShowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextField *content;

@property (nonatomic, strong) ContentBlock                    contextBlock;

- (void)setContextBlock:(ContentBlock)contextBlock;

@end
