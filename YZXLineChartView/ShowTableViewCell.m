//
//  ShowTableViewCell.m
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/22.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ShowTableViewCell.h"

@interface ShowTableViewCell ()<UITextFieldDelegate>

@end

@implementation ShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShowTableViewCell" owner:self options:nil] firstObject];
        
        self.title.delegate = self;
        self.content.delegate = self;
    }
    return self;
}

#pragma mark - <UITextFieldDelegate>
#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        if (textField == self.title) {
            self.contextBlock(textField.text,@"title");
        }else {
            self.contextBlock(textField.text,@"content");
        }
    }
}

@end
