//
//  TestViewController.m
//  zsfy
//
//  Created by 李晓飞 on 15/12/3.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "TestViewController.h"
#import "HawkManyFormsUIView.h"
#import "HawkManyFormsNoDateUIView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[[HawkManyFormsNoDateUIView alloc] initWithFrame:self.view.bounds withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
        NSLog(@"tap");
    }]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
