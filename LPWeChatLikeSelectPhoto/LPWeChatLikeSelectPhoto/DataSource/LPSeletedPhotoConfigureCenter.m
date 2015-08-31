//
//  ChoosePhotoDataSource.m
//  CheDingDong
//
//  Created by lipeng on 15/8/20.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPSeletedPhotoConfigureCenter.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChoosePhotoModel.h"
@interface LPSeletedPhotoConfigureCenter ()
@property (nonatomic,assign,readwrite) NSUInteger maxSelectedPhotoNum;
@end

@implementation LPSeletedPhotoConfigureCenter
+ (instancetype)shareInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)configureMaxSelectedPhotoNum:(NSUInteger)maxNum{

        self.maxSelectedPhotoNum=maxNum;
}
-(void)resetSelectedPhotoNum {
    self.selectedPhotoNum=nil;
}
-(BOOL)isSelectedPhotoNumNotLessThanMaxNum {
    return self.selectedPhotoNum.integerValue>=self.maxSelectedPhotoNum?YES:NO;
}
@end
