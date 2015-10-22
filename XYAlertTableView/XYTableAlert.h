//
//  XYTableAlert.h
//
//  Version 1.0
//
//  Created by 周文超 on 15/5/27.
//  Copyright (c) 2015年 xyre.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class XYTableAlert;

// 定义block回调
typedef NSInteger (^XYTableAlertNumberOfRowsBlock)(NSInteger section);
typedef UITableViewCell* (^XYTableAlertTableCellsBlock)(XYTableAlert *alert, NSIndexPath *indexPath);
typedef void (^XYTableAlertRowSelectionBlock)(NSIndexPath *selectedIndex);
typedef void (^XYTableAlertCompletionBlock)(void);


@interface XYTableAlert : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) XYTableAlertCompletionBlock completionBlock;	// Called when Cancel button pressed
@property (nonatomic, strong) XYTableAlertRowSelectionBlock selectionBlock;	// Called when a row in table view is pressed


// Classe method; rowsBlock and cellsBlock MUST NOT be nil 
+(XYTableAlert *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(XYTableAlertNumberOfRowsBlock)rowsBlock andCells:(XYTableAlertTableCellsBlock)cellsBlock;

// Initialization method; rowsBlock and cellsBlock MUST NOT be nil
-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(XYTableAlertNumberOfRowsBlock)rowsBlock andCells:(XYTableAlertTableCellsBlock)cellsBlock;

// Allows you to perform custom actions when a row is selected or the cancel button is pressed
-(void)configureSelectionBlock:(XYTableAlertRowSelectionBlock)selBlock andCompletionBlock:(XYTableAlertCompletionBlock)comBlock;

// Show the alert
-(void)show;

@end

