//
//  ChoosePhotoModel.h
//  CheDingDong
//
//  Created by lipeng on 15/8/20.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoosePhotoModel : NSObject

@property (nonatomic,strong,readonly) NSURL *assetsURL;
@property (nonatomic,assign,readwrite) BOOL  isSelected;
@property (nonatomic,strong,readwrite) NSDate *latestSelectedTime;
- (instancetype)initWithAssetsURL:(NSURL*)assetsURL;
@end
