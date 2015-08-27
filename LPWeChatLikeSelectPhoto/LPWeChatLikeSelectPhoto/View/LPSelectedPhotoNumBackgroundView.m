//
//  SelectedPhotoNumBackgroundView.m
//  LIPWeChatAddPhoto
//
//  Created by 李鹏 on 15/8/24.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "LPSelectedPhotoNumBackgroundView.h"

@implementation LPSelectedPhotoNumBackgroundView
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)animate {
    
    self.transform=CGAffineTransformScale(self.transform, 0.6, 0.6);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.transform=CGAffineTransformScale(self.transform, 0.9, 0.9);
        [UIView animateWithDuration:0.25 animations:^{
            self.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
@end
