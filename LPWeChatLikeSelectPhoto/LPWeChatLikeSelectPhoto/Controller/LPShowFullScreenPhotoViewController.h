//
//  ShowFullScreenPhotoViewController.h
//  CheDingDong
//
//  Created by lipeng on 15/8/19.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPSeletedPhotoConfigureCenter.h"
@interface LPShowFullScreenPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) NSUInteger currentPhotoIndex;
@property (nonatomic,strong) NSMutableArray *choosePhotoModelArray;
@property (nonatomic,strong) LPSeletedPhotoConfigureCenter *dataSource;
@end
