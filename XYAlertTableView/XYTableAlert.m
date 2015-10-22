//
//  XYTableAlert.m
//
//  Version 1.0
//
//  Created by 周文超 on 15/5/27.
//  Copyright (c) 2015年 xyre.com. All rights reserved.
//

#import "XYTableAlert.h"

#define kTableAlertWidth     304.0
#define kLateralInset         2.0
#define kVerticalInset         8.0
#define kMinAlertHeight      264.0
#define kCancelButtonHeight   40.0
#define kCancelButtonMargin    10.0
#define kTitleLabelMargin     2.0

@interface XYTableAlert ()
@property (nonatomic, strong) UIView *alertBg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;

// 标题与内容直接的分割线
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic) BOOL cellSelected;

@property (nonatomic, strong) XYTableAlertNumberOfRowsBlock numberOfRows;
@property (nonatomic, strong) XYTableAlertTableCellsBlock cells;

-(void)createBackgroundView;
-(void)animateIn;
-(void)animateOut;
-(void)dismissTableAlert;
@end

@implementation XYTableAlert

#pragma mark - XYTableAlert代理
+(XYTableAlert *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(XYTableAlertNumberOfRowsBlock)rowsBlock andCells:(XYTableAlertTableCellsBlock)cellsBlock
{
	return [[self alloc] initWithTitle:title cancelButtonTitle:cancelBtnTitle numberOfRows:rowsBlock andCells:cellsBlock];

}

#pragma mark - XYTableAlert 实现
-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle numberOfRows:(XYTableAlertNumberOfRowsBlock)rowsBlock andCells:(XYTableAlertTableCellsBlock)cellsBlock
{
	// 判断行
	if (rowsBlock == nil || cellsBlock == nil)
	{
		[[NSException exceptionWithName:@"rowsBlock and cellsBlock Error" reason:@"block不能为nil" userInfo:nil] raise];
		return nil;
	}
	
	self = [super init];
	if (self)
	{
		_numberOfRows = rowsBlock;
		_cells = cellsBlock;
		_title = title;
		_cancelButtonTitle = cancelButtonTitle;
		_height = kMinAlertHeight; // 设置默认高度
	}
	return self;
}

#pragma mark - Actions
-(void)configureSelectionBlock:(XYTableAlertRowSelectionBlock)selBlock andCompletionBlock:(XYTableAlertCompletionBlock)comBlock
{
	self.selectionBlock = selBlock;
	self.completionBlock = comBlock;
}

-(void)createBackgroundView
{
	// 创建弹窗背景
	self.cellSelected = NO;
	
	// 添加样式
	self.frame = [[UIScreen mainScreen] bounds];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
	self.opaque = NO;
	
	// 添加到window上
	UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    appWindow.backgroundColor = [UIColor clearColor];
	[appWindow addSubview:self];
	
	// 设置背景颜色
	[UIView animateWithDuration:0.2 animations:^{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
	}];
}

-(void)animateIn
{
	// 设置对话框弹出效果
	self.alertBg.transform = CGAffineTransformMakeScale(0.5, 0.5);
	[UIView animateWithDuration:0.2 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(1.0, 1.0);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(1.0, 1.0);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/7.5 animations:^{
				self.alertBg.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
}

-(void)animateOut
{
	[UIView animateWithDuration:1.0/7.5 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(1.0, 1.0);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(1.0, 1.0);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
				self.alpha = 0.3;
			} completion:^(BOOL finished){
				// 移除
				[self removeFromSuperview];
			}];
		}];
	}];
}

-(void)show
{
	[self createBackgroundView];
	
	// 创建对话框
	self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.alertBg];

    // 定义一个titleView
    UIView *titleView = [[UIView alloc] init];
    titleView.frame =  CGRectMake(kLateralInset, 0.0, kTableAlertWidth - 2 * kLateralInset, self.height - kLateralInset * 2);
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.cornerRadius = 5;
    titleView.layer.masksToBounds = YES;
    [self.alertBg addSubview:titleView];

    // 设置对话框的背景
    UIView *alertBgImage = [[UIView alloc] init];
    alertBgImage.backgroundColor = [UIColor whiteColor];
    alertBgImage.alpha = 0.5;
    alertBgImage.frame = CGRectMake(kLateralInset, 0.0, kTableAlertWidth - 2 * kLateralInset, self.height - kLateralInset * 2 - 5);
    [self.alertBg addSubview:alertBgImage];

	// 创建对话框标题
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor darkGrayColor];
	self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.font = [UIFont systemFontOfSize:20.0];
	self.titleLabel.frame = CGRectMake(6, 0, kTableAlertWidth - kLateralInset * 2,47);
	self.titleLabel.text = self.title;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[titleView addSubview:self.titleLabel];

    // 添加一条分割线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(kLateralInset, 53, [UIScreen mainScreen].bounds.size.width - kLateralInset, 1)];
    self.lineView.backgroundColor = [UIColor colorWithRed:215/ 255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    [titleView addSubview:self.lineView];
	
	// 创建tableView
	self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.table.frame = CGRectMake(kLateralInset, 54, kTableAlertWidth - kLateralInset * 2, (self.height - kVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - kTitleLabelMargin - kCancelButtonMargin - kCancelButtonHeight +10);
    self.table.rowHeight = 65;
	self.table.delegate = self;
	self.table.dataSource = self;
	self.table.backgroundView = [[UIView alloc] init];
	[self.alertBg addSubview:self.table];
    self.table.tableFooterView = [[UIView alloc] init];

    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]){
        [self.table setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]){
        [self.table setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }


	// 创建取消按钮
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.cancelButton.frame = CGRectMake(kLateralInset, self.table.frame.origin.y + self.table.frame.size.height + kCancelButtonMargin - 10, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
	self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
	[self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	[self.cancelButton setBackgroundColor:[UIColor whiteColor]];
	[self.cancelButton addTarget:self action:@selector(dismissTableAlert) forControlEvents:UIControlEventTouchUpInside];
	[self.alertBg addSubview:self.cancelButton];

    // 添加一条分割线
    self.lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTableAlertWidth - 3, 1)];
    self.lineView2.backgroundColor = [UIColor colorWithRed:215/ 255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    self.lineView2.alpha = 0.5;
    [self.cancelButton addSubview:self.lineView2];

	
	// 设置对话框的尺寸
	self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2, kTableAlertWidth, self.height - kVerticalInset * 2 );

    // 成为第一响应者
	[self becomeFirstResponder];
	
	// 设置显示的动画
	[self animateIn];
}

-(void)dismissTableAlert
{
	// 隐藏对话框
	[self animateOut];
	if (self.completionBlock != nil)
		if (!self.cellSelected)
			self.completionBlock();
}

// Allows the alert to be first responder
-(BOOL)canBecomeFirstResponder
{
	return YES;
}

// Alert height setter
-(void)setHeight:(CGFloat)height
{
	if (height > kMinAlertHeight)
		_height = height;
	else
		_height = kMinAlertHeight;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// TODO: Allow multiple sections
	return 1;
}

// 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// 设置组数
	return self.numberOfRows(section);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.cells(self, indexPath);
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// 监听取消按钮
	self.cellSelected = YES;
	// dismiss the alert
	[self dismissTableAlert];
	
	// perform actions contained in the selectionBlock if it isn't nil
	// add pass the selected indexPath
	if (self.selectionBlock != nil)
		self.selectionBlock(indexPath);
}

- (UIColor *)colorWithHexadecimalString:(NSString *)colorValue withColorAlpha:(float)alpha
{
    UIColor *color = [UIColor clearColor];
    if ([[colorValue substringToIndex:1] isEqualToString:@"#"]) {
        if ([colorValue length] == 7) {
            NSRange range = NSMakeRange(1, 2);
            NSString *redString = [colorValue substringWithRange:range];
            range.location = 3;
            NSString *greenString = [colorValue substringWithRange:range];
            range.location = 5;
            NSString *blueString = [colorValue substringWithRange:range];

            float r = [self getIntegerFromString:redString];
            float g = [self getIntegerFromString:greenString];
            float b = [self getIntegerFromString:blueString];
            color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:alpha];
        }
    }
    return color;
}

- (int) getIntegerFromString:(NSString *)str
{
    int nValue = 0;
    for (int i = 0; i < [str length]; i++)
    {
        int nLetterValue = 0;

        if ([str characterAtIndex:i] >='0' && [str characterAtIndex:i] <='9') {
            nLetterValue += ([str characterAtIndex:i] - '0');
        }
        else{
            switch ([str characterAtIndex:i])
            {
                case 'a':case 'A':
                    nLetterValue = 10;break;
                case 'b':case 'B':
                    nLetterValue = 11;break;
                case 'c': case 'C':
                    nLetterValue = 12;break;
                case 'd':case 'D':
                    nLetterValue = 13;break;
                case 'e': case 'E':
                    nLetterValue = 14;break;
                case 'f': case 'F':
                    nLetterValue = 15;break;
                default:nLetterValue = '0';
            }
        }

        nValue = nValue * 16 + nLetterValue; //16进制
    }
    return nValue;
}
@end
