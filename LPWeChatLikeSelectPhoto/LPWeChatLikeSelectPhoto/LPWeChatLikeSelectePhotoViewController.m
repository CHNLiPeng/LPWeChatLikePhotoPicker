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
#import "LPSeletedPhotoConfigureCenter.h"
@interface LPWeChatLikeSelectePhotoViewController ()
@property (nonatomic,copy) FinishChoosingPhotoBlock finishChoosingPhotoBlock;
@property (nonatomic,assign) NSUInteger maxNum;
@property (nonatomic,strong) UINavigationController *nav;
@end

@implementation LPWeChatLikeSelectePhotoViewController
- (instancetype)initWithMaxPhotoNum:(NSUInteger)maxNum finishChoosing:(FinishChoosingPhotoBlock)finishChoosingBlock {
    NSAssert(maxNum!=0, @"maxPhotoNum must not be Zero(0)");
    NSAssert(finishChoosingBlock!=nil, @"finishChoosingBlock must not be nil");
    self=[super init];
    if(self) {
        _finishChoosingPhotoBlock=finishChoosingBlock;
        _maxNum=maxNum;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerNotification];
    [[LPSeletedPhotoConfigureCenter shareInstance] configureMaxSelectedPhotoNum:self.maxNum];
    [self addChildViewController:self.nav];
    [self.view addSubview:self.nav.view];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Register Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonClicked:) name:@"LPCancelButtonDidClickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishButtonClicked:) name:@"LPFinishButtonDidClickedNotification" object:nil];
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

#pragma mark - Setter & Getter 
-(UINavigationController *)nav {
    if(!_nav) {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"AddPhoto" bundle:nil];
        _nav=[storyBoard instantiateInitialViewController];
        
        LPChoosePhotoViewController *choosePhotoViewController=[storyBoard instantiateViewControllerWithIdentifier:[[LPChoosePhotoViewController class] description]];
        
        [self.nav pushViewController:choosePhotoViewController animated:NO];
    }
    return _nav;
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
