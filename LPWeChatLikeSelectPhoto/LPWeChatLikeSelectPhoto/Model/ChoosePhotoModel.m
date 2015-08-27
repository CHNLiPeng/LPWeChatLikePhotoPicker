//
//  ChoosePhotoModel.m
//  CheDingDong
//
//  Created by lipeng on 15/8/20.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "ChoosePhotoModel.h"

@interface ChoosePhotoModel ()
@property (nonatomic,strong,readwrite) NSURL *assetsURL;
@end

@implementation ChoosePhotoModel
- (instancetype)initWithAssetsURL:(NSURL*)assetsURL {
    self.assetsURL=assetsURL;
    self.isSelected=NO;
    return self;
}
@end
