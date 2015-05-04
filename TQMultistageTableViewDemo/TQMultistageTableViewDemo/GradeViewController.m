//
//  GradeViewController.m
//  LoreWealth
//
//  Created by lei xue on 15-4-3.
//  Copyright (c) 2015年 LoreWealth. All rights reserved.
//

#import "GradeViewController.h"
#import "TQMultistageTableView.h"

static const int kGradeViewSectionHeight = 44;
static const int kGradeViewRowHeight = 33;

@interface GradeViewController ()<TQTableViewDataSource,TQTableViewDelegate>
@property(strong, nonatomic) TQMultistageTableView *multistageTableView;
@property(strong, nonatomic) NSMutableArray *sectionArray;//sections for table view.
@property(strong, nonatomic) NSArray *schoolCategories;
@property(strong, nonatomic) NSArray *grades;
@property(copy, nonatomic) NSString *schoolName;
@property(strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation GradeViewController
@synthesize multistageTableView;
@synthesize sectionArray;
@synthesize schoolCategories;
@synthesize grades;
@synthesize schoolName;
@synthesize selectedIndexPath;

-(id)init{
    self = [super init];
    if (self) {
        schoolCategories = @[@"小学 ∨", @"初中 ∨", @"高中 ∨"];
        grades = @[@[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"], @[@"初一", @"初二", @"初三"], @[@"高一", @"高二", @"高三"]];
        selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.multistageTableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.multistageTableView.tableView.bounces = NO;
    self.multistageTableView.dataSource = self;
    self.multistageTableView.delegate = self;
    self.multistageTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.multistageTableView];
    
    sectionArray = [NSMutableArray arrayWithCapacity:[schoolCategories count]];
    for (int i = 0; i < [schoolCategories count]; ++i) {
        UIView *sectionView = [[UIView alloc] init];//TQMultistageTableView内部会设置section的frame。
        
        //label MUST be the first subview of sectionView.
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kGradeViewSectionHeight)];
        label.text = schoolCategories[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1];
        [sectionView addSubview:label];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kGradeViewSectionHeight - 0.5, self.view.frame.size.width, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [sectionView addSubview:bottomLine];
        
        [sectionArray addObject:sectionView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    //因为有navigation bar，所以self.view.frame.size.height会重新调整。
    CGRect frame = self.multistageTableView.frame;
    if (frame.size.width < 1) {//之前未设置tableView.frame.size
        frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.multistageTableView.frame = frame;
        self.multistageTableView.tableView.frame = frame;
    }
}

#pragma mark - TQTableViewDataSource
- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    return [grades[section] count];
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, kGradeViewRowHeight - 1, self.view.frame.size.width - 20, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:1 green:245.0/255 blue:238.0/255 alpha:1];
        [cell.contentView addSubview:bottomLine];
    }
    
    cell.textLabel.text = grades[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return [schoolCategories count];
}

#pragma mark - Table view delegate
- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return kGradeViewSectionHeight;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGradeViewRowHeight;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    return sectionArray[section];
}

- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %d %d", indexPath.section, indexPath.row);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    UILabel *label = ((UIView *)sectionArray[section]).subviews[0];
    label.text = [label.text stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"∧"];
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    UILabel *label = ((UIView *)sectionArray[section]).subviews[0];
    label.text = [label.text stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"∨"];
}

@end
