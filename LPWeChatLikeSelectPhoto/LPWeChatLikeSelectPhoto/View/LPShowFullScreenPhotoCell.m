//
//  ShowFullScreenPhotoCell.m
//  CheDingDong
//
//  Created by lipeng on 15/8/19.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPShowFullScreenPhotoCell.h"

@interface LPShowFullScreenPhotoCell ()<UIScrollViewDelegate>



@property (nonatomic,assign) CGFloat zoomScale;
@end

@implementation LPShowFullScreenPhotoCell
-(void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //self.scrollView.frame=self.contentView.frame;
    self.scrollView.maximumZoomScale=2.0;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.contentSize=self.contentView.bounds.size;
    self.scrollView.delegate=self;
    self.zoomScale=1;
    [self.contentView addSubview:self.scrollView];
    // Add gesture,double tap zoom imageView.
    
    self.imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    self.imageView.userInteractionEnabled=YES;
    [ self.imageView addGestureRecognizer:doubleTapGesture];
    
    self.scrollView.contentSize=self.contentView.bounds.size;
    [self.scrollView addSubview:self.imageView];
    
}
- (void)configureCellWithImage:(UIImage *)image {
    self.imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    self.imageView.userInteractionEnabled=YES;
    [ self.imageView addGestureRecognizer:doubleTapGesture];
    
    
    [self.scrollView addSubview:self.imageView];
}

-(void)handleDoubleTap:(UIGestureRecognizer*)gesture {
    NSLog(@"%s",__func__);
    if(self.zoomScale==1)
    {
        
        [self.scrollView setZoomScale:2.0 animated:YES];
        self.zoomScale=2.0;
        CGSize contentSize=self.scrollView.contentSize;
        NSLog(@"%f,  %f",contentSize.height,contentSize.width);
        CGRect rect=self.scrollView.frame;
        contentSize.height=contentSize.height;
        self.scrollView.contentSize=contentSize;
        
    } else
    {
        [self.scrollView setZoomScale:1.0 animated:YES];
        self.zoomScale=1.0;
        
    }
    
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"%s",__func__);
}
@end
