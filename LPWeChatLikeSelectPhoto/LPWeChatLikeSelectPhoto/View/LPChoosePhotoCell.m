//
//  ChoosePhotoCell.m
//  CheDingDong
//
//  Created by lipeng on 15/8/18.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPChoosePhotoCell.h"

@interface LPChoosePhotoCell ()

@end

@implementation LPChoosePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.blueView.hidden=YES;
    
   
}
- (IBAction)selectionButtonClicked:(UIButton *)sender {

    if(self.selectionButtonClickedBlock) {
        self.selectionButtonClickedBlock();
    }
}

@end
