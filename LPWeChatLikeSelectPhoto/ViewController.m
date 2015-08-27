//
//  ViewController.m
//  LPWeChatLikeSelectPhoto
//
//  Created by 李鹏 on 15/8/25.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "ViewController.h"
#import "LPWeChatLikeSelectPhoto/LPWeChatLikeSelectePhotoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClicked:(id)sender {
   LPWeChatLikeSelectePhotoViewController *vc=[[LPWeChatLikeSelectePhotoViewController alloc]initWithMaxPhotoNum:9 finishChoosing:^(NSArray *selectedAssetsURLArray) {
       NSLog(@"%@",selectedAssetsURLArray);
   }];
    [self presentViewController:vc animated:YES completion:NULL];
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
