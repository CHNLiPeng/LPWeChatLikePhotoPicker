//
//  ChoosePhotoCell.h
//  CheDingDong
//
//  Created by lipeng on 15/8/18.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectionButtonClickedBlock)();
@interface LPChoosePhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (nonatomic,copy) SelectionButtonClickedBlock selectionButtonClickedBlock;
@end
