//
//  ShowFullScreenPhotoViewController.m
//  CheDingDong
//
//  Created by lipeng on 15/8/19.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPShowFullScreenPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LPShowFullScreenPhotoCell.h"
#import "ChoosePhotoModel.h"
#import "LPSelectedPhotoNumBackgroundView.h"
static NSString *identifier= @"LPShowFullScreenPhotoCell";

@interface LPShowFullScreenPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottonView;
@property (weak, nonatomic) IBOutlet UILabel *selectedPhotoNumLabel;
@property (weak, nonatomic) IBOutlet LPSelectedPhotoNumBackgroundView *selectedPhotoNumBackgroudView;
@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,assign) BOOL  isFirstTimeReloadData;
@property (nonatomic,strong) ALAssetsLibrary *assetslibrary;
@end

@implementation LPShowFullScreenPhotoViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(self.dataSource!=nil, @"DataSource must not be nil!");
    NSAssert(self.choosePhotoModelArray!=nil, @"ChoosePhotoModelArray must not be nil!");
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.selectButton];
    //为label和button的状态赋初值
    ChoosePhotoModel *model=self.choosePhotoModelArray[self.currentPhotoIndex];
    self.selectButton.selected=model.isSelected;
    self.selectedPhotoNumLabel.text=self.dataSource.selectedPhotoNum.stringValue;
    self.selectedPhotoNumBackgroudView.hidden=self.dataSource.selectedPhotoNum.integerValue==0?YES:NO;
    
    [self.dataSource addObserver:self forKeyPath:@"selectedPhotoNum" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view insertSubview:self.bottonView aboveSubview:self.collectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isFirstTimeReloadData=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.isFirstTimeReloadData) {
        return;
    }else
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPhotoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.isFirstTimeReloadData=NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc {
    [self.dataSource removeObserver:self forKeyPath:@"selectedPhotoNum" context:NULL];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

#pragma mark - Target action
- (void)selectButtonClicked:(UIButton*)sender {
    NSIndexPath *indexPath=[[self.collectionView indexPathsForVisibleItems] firstObject];
    ChoosePhotoModel *model=self.choosePhotoModelArray[indexPath.row];
    
    [self selectChoosePhotoModel:model];
}
- (IBAction)finishButtonClicked:(id)sender {
    if([self noPhotoSelectd]) {
        NSIndexPath *indexPath=[[self.collectionView indexPathsForVisibleItems] firstObject];
        ChoosePhotoModel *model=self.choosePhotoModelArray[indexPath.row];
        if(!model.isSelected){
            [self selectChoosePhotoModel:model];
        }
    }
        
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LPFinishButtonDidClickedNotification" object:nil userInfo:@{@"selectedAssetsURL":[self gernateSelectedAssetsURLArray]}];
}

#pragma mark - Private Method
- (NSArray*)gernateSelectedAssetsURLArray {
    NSMutableArray *selectedModelArray=[NSMutableArray array];
    for (ChoosePhotoModel *model in self.choosePhotoModelArray) {
        if(model.isSelected) {
            [selectedModelArray addObject:model];
        }
    }
    NSArray *sortedArray= [selectedModelArray sortedArrayUsingComparator:^NSComparisonResult(ChoosePhotoModel *obj1, ChoosePhotoModel *obj2) {
        NSDate *earlier=[obj1.latestSelectedTime earlierDate:obj2.latestSelectedTime];
        if(earlier==obj1.latestSelectedTime){
            return NO;
        }else
        {
            return YES;
        }
    }];
    NSMutableArray *assetsURLArray=[NSMutableArray array];
    for (ChoosePhotoModel *model in sortedArray) {
        [assetsURLArray addObject:model.assetsURL];
    }
    return assetsURLArray.copy;
}
- (BOOL)noPhotoSelectd {
    for (ChoosePhotoModel *model in self.choosePhotoModelArray) {
        if(model.isSelected)
        {
            return NO;
        }
    }
    return YES;
}
- (void)selectChoosePhotoModel:(ChoosePhotoModel*)model {
    BOOL isGreaterThanNight=self.dataSource.selectedPhotoNum.integerValue>=9&&model.isSelected==NO;
    if(isGreaterThanNight){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"你最多只能选择9张照片" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    model.isSelected=!model.isSelected;
    self.selectButton.selected=model.isSelected;
    model.latestSelectedTime=[NSDate date];
    NSUInteger count=0;
    for (ChoosePhotoModel *model in self.choosePhotoModelArray) {
        count=model.isSelected?++count:count;
    }
    self.dataSource.selectedPhotoNum=@(count);
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.choosePhotoModelArray.count;
};

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPShowFullScreenPhotoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ChoosePhotoModel *model=self.choosePhotoModelArray[indexPath.row];
        [self.assetslibrary assetForURL:model.assetsURL resultBlock:^(ALAsset *asset) {
            UIImage *fulScreenImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            cell.imageView.image =fulScreenImage;
        } failureBlock:^(NSError *error) {
            
        }];
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[UIScreen mainScreen] bounds].size;
    ;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bottonView.alpha=self.bottonView.alpha?0:1;
        self.navigationController.navigationBar.alpha=self.navigationController.navigationBar.alpha?0:1;
    }];
   
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath=[[self.collectionView indexPathsForVisibleItems] firstObject];
    ChoosePhotoModel *model =self.choosePhotoModelArray[indexPath.row];
    self.selectButton.selected=model.isSelected;
}
#pragma mark - Setter And Getter
- (ALAssetsLibrary *)assetslibrary {
    if(!_assetslibrary) {
        _assetslibrary= [[ALAssetsLibrary alloc]init];
    }
    return _assetslibrary;
}
- (UIButton*)selectButton {
    if(!_selectButton) {
        _selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.frame=CGRectMake(0, 0, 44,44);
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_selectButton setImage:[UIImage imageNamed:@"icon_selection_h"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"icon-照片选择-蓝色"] forState:UIControlStateSelected];
    }
    return _selectButton;
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"selectedPhotoNum"])
    {
        if(self.dataSource.selectedPhotoNum.integerValue==0){
            self.selectedPhotoNumBackgroudView.hidden=YES;
            self.selectedPhotoNumLabel.text=@"";
            
        }else {
            self.selectedPhotoNumBackgroudView.hidden=NO;
            self.selectedPhotoNumLabel.text=[NSString stringWithFormat:@"%@",self.dataSource.selectedPhotoNum];
            [self.selectedPhotoNumBackgroudView animate];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
