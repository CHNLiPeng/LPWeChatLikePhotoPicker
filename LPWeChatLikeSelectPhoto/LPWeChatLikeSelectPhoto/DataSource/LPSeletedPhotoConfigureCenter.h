//
//  ChoosePhotoDataSource.h
//  CheDingDong
//
//  Created by lipeng on 15/8/20.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LPSeletedPhotoConfigureCenter : NSObject
@property (nonatomic,strong,readwrite) NSNumber *selectedPhotoNum;
@property (nonatomic,assign,readonly) NSUInteger maxSelectedPhotoNum;
+ (instancetype)shareInstance;
- (void)configureMaxSelectedPhotoNum:(NSUInteger)maxNum;

- (void)resetSelectedPhotoNum;
- (BOOL)isSelectedPhotoNumNotLessThanMaxNum;
@end
