//
//  ChoosePhotoDataSource.m
//  CheDingDong
//
//  Created by lipeng on 15/8/20.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "SeletedPhotoNumberDataSource.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChoosePhotoModel.h"
@interface SeletedPhotoNumberDataSource ()

@end

@implementation SeletedPhotoNumberDataSource
+ (instancetype)shareInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
