//
//  ChoosePhotoViewController.h
//  CheDingDong
//
//  Created by lipeng on 15/8/18.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWeChatLikeSelectePhotoViewController.h"
@class LPSeletedPhotoConfigureCenter;
@interface LPChoosePhotoViewController : UIViewController
@property (nonatomic,strong) NSURL *assetsGroupURL;
@property (nonatomic,strong) LPSeletedPhotoConfigureCenter *dataSource;
@end
