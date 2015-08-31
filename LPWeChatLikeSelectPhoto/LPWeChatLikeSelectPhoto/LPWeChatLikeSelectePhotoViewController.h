//
//  LPWeChatLikeSelectePhotoViewController.h
//  LPWeChatLikeSelectPhoto
//
//  Created by 李鹏 on 15/8/25.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FinishChoosingPhotoBlock)(NSArray *selectedAssetsURLArray);
@interface LPWeChatLikeSelectePhotoViewController : UIViewController

- (instancetype)initWithMaxPhotoNum:(NSUInteger)maxNum finishChoosing:(FinishChoosingPhotoBlock)finishChoosingBlock;
@end
