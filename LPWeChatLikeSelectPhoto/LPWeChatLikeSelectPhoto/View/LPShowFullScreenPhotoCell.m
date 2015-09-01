//
//  ShowFullScreenPhotoCell.m
//  CheDingDong
//
//  Created by lipeng on 15/8/19.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPShowFullScreenPhotoCell.h"

@interface LPShowFullScreenPhotoCell ()<UIScrollViewDelegate>

@property (nonatomic,copy) SingleTapImageBlock singleTapImageBlock;
@property (nonatomic,strong) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic,assign) CGFloat zoomScale;
@end

@implementation LPShowFullScreenPhotoCell
-(void)awakeFromNib {
    [super awakeFromNib];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize=self.contentView.bounds.size;
    [self.imageView addGestureRecognizer:self.doubleTapGesture];
    [self.imageView addGestureRecognizer:self.singleTapGesture];
    [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    [self.contentView addSubview:self.scrollView];

}
- (void)configureCellWithImage:(UIImage *)image  singleTapImage:(SingleTapImageBlock)singleTapImageBlock {
    self.singleTapImageBlock=singleTapImageBlock;
    self.imageView.image=image;
}

-(void)handleDoubleTap:(UIGestureRecognizer*)gesture {
    if(self.zoomScale==1)
    {
        CGFloat scale = self.scrollView.frame.size.height/(self.imageView.image.size.height/3);
        [self.scrollView setZoomScale:scale animated:YES];
        self.zoomScale=scale;
        CGSize contentSize=self.scrollView.contentSize;
        NSLog(@"%f,%f",contentSize.height,contentSize.width);
//        NSLog(@"%f,  %f",contentSize.height,contentSize.width);
//        contentSize.height=contentSize.height;
      //  self.scrollView.contentSize=self.imageView.image.s;
        
    } else
    {
        [self.scrollView setZoomScale:1.0 animated:YES];
        self.zoomScale=1.0;
        CGSize contentSize=self.scrollView.contentSize;
        NSLog(@"%f,%f",contentSize.height,contentSize.width);
        
    }
    
}
-(void)handleSingleTap:(UIGestureRecognizer*)gesture {
    if(self.singleTapImageBlock)
    {
        self.singleTapImageBlock();
    }
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma makr - Setter & Getter 
-(UITapGestureRecognizer *)doubleTapGesture {
    if(!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleDoubleTap:)];
        [_doubleTapGesture setNumberOfTapsRequired:2];
    }
    return _doubleTapGesture;
}

-(UITapGestureRecognizer *)singleTapGesture {
    if(!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handleSingleTap:)];
        _singleTapGesture.delaysTouchesBegan=YES;
    }
    return _singleTapGesture;
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.maximumZoomScale=5.0;
        _scrollView.minimumZoomScale=1.0;
        _scrollView.delegate=self;
        _zoomScale=1;
    }
    return _scrollView;
}
- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView=[[UIImageView alloc]initWithFrame:self.scrollView.bounds];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled=YES;
    }
    return _imageView;
}

@end
