//
//  SelectedPhotoNumBackgroundView.h
//  LIPWeChatAddPhoto
//
//  Created by 李鹏 on 15/8/24.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface LPSelectedPhotoNumBackgroundView : UIView
@property (nonatomic) IBInspectable CGFloat cornerRadius;
- (void)animate;
@end
