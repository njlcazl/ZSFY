//
//  LawSelectViewController.m
//  zsfy
//
//  Created by eshore_it on 15-12-2.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "LawSelectViewController.h"
#import "FYTableViewCell.h"
@interface LawSelectViewController ()
{
    NSInteger current;
}
@property (nonatomic,strong)NSArray *btnArr;

@end



@implementation LawSelectViewController
- (NSArray *)btnArr
{
    if (_btnArr == nil) {
        if (_year >= 2016) {
            self.btnArr = @[@"粤71", @"粤7101", @"粤7102"];
        } else {
            self.btnArr= @[@"广铁中法",@"广铁法",@"肇铁法"];
        }
       
    }
    return _btnArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.view.backgroundColor = FYBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * getSelect = [userDefaults valueForKey:@"lowSelect"];
    if (getSelect) {
        current = [self.btnArr indexOfObject:getSelect];

    }
    else{
        current = 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.btnArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"Cell";
    FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[FYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if (current == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = self.btnArr[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *select = self.btnArr[indexPath.row];
    [userDefaults setObject:select forKey:@"lowSelect"];
    [userDefaults synchronize];
    current = indexPath.row;
    [self.tableView reloadData];
    if (self.selLow) {
        self.selLow();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
