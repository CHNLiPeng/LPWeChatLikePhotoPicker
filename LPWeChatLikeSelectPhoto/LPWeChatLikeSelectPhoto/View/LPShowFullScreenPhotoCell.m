//
//  ShowFullScreenPhotoCell.m
//  CheDingDong
//
//  Created by lipeng on 15/8/19.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPShowFullScreenPhotoCell.h"

@interface LPShowFullScreenPhotoCell ()
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation LPShowFullScreenPhotoCell
-(void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //self.scrollView.frame=self.contentView.frame;
    self.scrollView.maximumZoomScale=3.0;
    self.scrollView.contentSize=self.contentView.bounds.size;
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [ self.imageView addGestureRecognizer:doubleTapGesture];
    [self.contentView addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.imageView];
    
}

-(void)handleDoubleTap:(UIGestureRecognizer*)gesture {
    NSLog(@"%s",__func__);
}
@end
