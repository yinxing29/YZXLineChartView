//
//  ViewController.m
//  YZXLineChartView
//
//  Created by 尹星 on 2016/12/21.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ViewController.h"
#import "ShowTableViewCell.h"
#import "DataModel.h"
#import "ShowViewController.h"
#import "Header.h"
#import "MJExtension.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;

@property (nonatomic, strong) NSMutableArray <DataModel *>   *modelArr;

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

@property (weak, nonatomic) IBOutlet UITextField *coordinateContentFont;

@property (weak, nonatomic) IBOutlet UITextField *annotationTitleFont;
@property (weak, nonatomic) IBOutlet UISwitch *hideAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"折线图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNavigationBarItem];
    [self initializeDataSource];
}

- (void)initializeDataSource
{
    self.maxScaleValue = 160000.0;
    self.calibrationIntervalValue = 10000.0;
    self.lineColor = [UIColor blackColor];
    self.coordinateColor = [UIColor blackColor];
    self.annotatinColor = [UIColor blueColor];
    
    NSArray *modelArr = @[@{@"title":@"title1title1title1title1title1title1title1title1title1title1",@"content":@"132000.0"},@{@"title":@"title2",@"content":@"100000.0"},@{@"title":@"title3",@"content":@"60123.0"},@{@"title":@"title4",@"content":@"65000.0"},@{@"title":@"title5",@"content":@"10000.0"}];
    self.modelArr = [DataModel mj_objectArrayWithKeyValuesArray:modelArr];
    [self.tableView reloadData];
}

- (void)customNavigationBarItem
{
    UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBut setTitle:@"添加" forState:UIControlStateNormal];
    [leftBut sizeToFit];
    [leftBut addTarget:self action:@selector(leftItemPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [rightBut sizeToFit];
    [rightBut addTarget:self action:@selector(rightItemPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftItemPressed
{
    DataModel *model = [[DataModel alloc] init];
    [self.modelArr addObject:model];
    [self.tableView reloadData];
}

- (void)rightItemPressed
{
    [self.view endEditing:YES];
    
    ShowViewController *showVC = [[ShowViewController alloc] init];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *contents = [NSMutableArray array];
    for (DataModel *model in self.modelArr) {
        if (![model.title isEqualToString:@""] && model.title) {
            [titles addObject:model.title];
        }
        if (![model.content isEqualToString:@""] && model.content) {
            [contents addObject:model.content];
        }
    }
    showVC.titleArr = titles.count == 0?nil:titles;
    showVC.contentArr = contents.count == 0?nil:contents;
    showVC.maxScaleValue = self.maxScaleValue;
    showVC.calibrationIntervalValue = self.calibrationIntervalValue;
    showVC.lineColor = self.lineColor;
    showVC.coordinateColor = self.coordinateColor;
    showVC.annotatinColor = self.annotatinColor;
    showVC.hideAnnotation = self.hideAnnotation.on;
    //设置之后坐标系内容字体大小不会根据内容多少而变化
//    showVC.coordinateContentFont = [self.coordinateContentFont.text floatValue];
    showVC.annotationTitleFont = [self.annotationTitleFont.text floatValue];
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"颜色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weak_self = self;
    for (NSString *key in [ColorDic allKeys]) {
        if (![key isEqualToString:@"随机"]) {
            [alertC addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [sender setTitle:key forState:UIControlStateNormal];
                if (sender.tag == 100) {//坐标系颜色
                    weak_self.coordinateColor = ColorDic[key];
                }else if (sender.tag == 101) {//折现颜色
                    weak_self.lineColor = ColorDic[key];
                }else {
                    weak_self.annotatinColor = ColorDic[key];
                }
            }]];
        }
    }
    [alertC addAction:[UIAlertAction actionWithTitle:@"随机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"随机" forState:UIControlStateNormal];
        if (sender.tag == 100) {//坐标系颜色
            weak_self.coordinateColor = ColorDic[@"随机"];
        }else if (sender.tag == 101) {//折现颜色
            weak_self.lineColor = ColorDic[@"随机"];
        }else {
            weak_self.annotatinColor = ColorDic[@"随机"];
        }
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 102) {//最大刻度
        self.maxScaleValue = [textField.text floatValue];
    }else if (textField.tag == 103){//量程
        self.calibrationIntervalValue = [textField.text floatValue];
    }
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.title.text = self.modelArr[indexPath.row].title;
    cell.content.text = self.modelArr[indexPath.row].content;
    
    __weak typeof(self) weak_self = self;
    [cell setContextBlock:^(NSString *content, NSString *type) {
        if ([type isEqualToString:@"title"]) {
            weak_self.modelArr[indexPath.row].title = content;
        }else {
            weak_self.modelArr[indexPath.row].content = content;
            
        }
    }];
    cell.selectionStyle = NO;
    self.tableViewConstraint.constant = self.tableView.contentSize.height;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.modelArr removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 初始化
- (NSMutableArray<DataModel *> *)modelArr
{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}

@end
