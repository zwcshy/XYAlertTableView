//
//  ViewController.m
//  XYAlertTableView
//
//  Created by 周文超 on 15/7/15.
//  Copyright (c) 2015年 com.xinyuan. All rights reserved.
//

#import "ViewController.h"
#import "XYTableAlert.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (strong, nonatomic) XYTableAlert *alert;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)showTableAlert:(id)sender {

    NSArray *arr = @[@"支付宝支付",@"U付支付"];
    NSArray *imgArr = @[@"iconfont-wodeqianbao",@"iconfont-alipay"];
    // 创建弹出框
    self.alert = [XYTableAlert tableAlertWithTitle:@"支付渠道选择" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section){
                      return arr.count;
                  }
                  andCells:^UITableViewCell* (XYTableAlert *anAlert, NSIndexPath *indexPath){
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                      cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imgArr[indexPath.row]]];
                      cell.textLabel.text = [NSString stringWithFormat:@"%@", arr[indexPath.row]];
                      cell.textLabel.font = [UIFont systemFontOfSize:17];
                      cell.textLabel.textColor = [UIColor darkGrayColor];
                      cell.textLabel.textAlignment = NSTextAlignmentLeft;
                      return cell;
                  }];

    // 设置弹出框的高度
    self.alert.height = 150;

    // 设置tableView每一行的点击
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        self.contentLbl.text = [NSString stringWithFormat:@"选择的商品是：%@", arr[selectedIndex.row]];
    } andCompletionBlock:^{
        self.contentLbl.text = @"点击取消按钮";
    }];

    // show the alert
    [self.alert show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
