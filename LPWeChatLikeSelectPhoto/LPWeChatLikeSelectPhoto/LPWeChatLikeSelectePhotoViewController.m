//
//  LPWeChatLikeSelectePhotoViewController.m
//  LPWeChatLikeSelectPhoto
//
//  Created by 李鹏 on 15/8/25.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "LPWeChatLikeSelectePhotoViewController.h"
#import "LPChoosePhotoViewController.h"
#import "LPChooseAlbumViewController.h"
@interface LPWeChatLikeSelectePhotoViewController ()
@property (nonatomic,copy) FinishChoosingPhotoBlock finishChoosingPhotoBlock;
@property (nonatomic,assign) NSUInteger maxNum;
@property (nonatomic,strong) UINavigationController *nav;
@end

@implementation LPWeChatLikeSelectePhotoViewController
- (instancetype)initWithMaxPhotoNum:(NSUInteger)maxNum finishChoosing:(FinishChoosingPhotoBlock)finishChoosingBlock {
    self=[super init];
    if(self) {
        _finishChoosingPhotoBlock=finishChoosingBlock;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonClicked:) name:@"LPCancelButtonDidClickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishButtonClicked:) name:@"LPFinishButtonDidClickedNotification" object:nil];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"AddPhoto" bundle:nil];
    self.nav=[storyBoard instantiateInitialViewController];
    [self addChildViewController:self.nav];
    [self.view addSubview:self.nav.view];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Notification 
- (void)cancelButtonClicked:(NSNotification*)notification {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)finishButtonClicked:(NSNotification*)notification {
    NSArray *array=notification.userInfo[@"selectedAssetsURL"];
    if(self.finishChoosingPhotoBlock)
    {
        self.finishChoosingPhotoBlock(array);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
