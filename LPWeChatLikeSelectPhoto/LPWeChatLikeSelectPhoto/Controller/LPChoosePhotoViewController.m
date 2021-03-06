//
//  ChoosePhotoViewController.m
//  CheDingDong
//
//  Created by lipeng on 15/8/18.
//  Copyright (c) 2015年 Riley. All rights reserved.
//
#define CellPadding 2
#define ItemSizeWidth [UIScreen mainScreen].bounds.size.width/4-CellPadding
#define ItemSizeHeight ItemSizeWidth

#import "LPChoosePhotoViewController.h"
#import "LPChoosePhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LPShowFullScreenPhotoViewController.h"
#import "ChoosePhotoModel.h"
#import "LPSeletedPhotoConfigureCenter.h"
#import "LPSelectedPhotoNumBackgroundView.h"
static NSString *identifier =@"LPChoosePhotoCell";
#define NAVBAR_CHANGE_POINT 50
@interface LPChoosePhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *selectedPhotoNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet LPSelectedPhotoNumBackgroundView *selectedPhotoNumBackgroundView;

@property (nonatomic,strong) NSMutableArray *choosePhotoModelArray;

@property (nonatomic,strong) ALAssetsLibrary *assetslibrary;
@end

@implementation LPChoosePhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource=[LPSeletedPhotoConfigureCenter shareInstance];
    [self.dataSource resetSelectedPhotoNum];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.choosePhotoModelArray=[NSMutableArray array];
    [self.dataSource addObserver:self forKeyPath:@"selectedPhotoNum" options:NSKeyValueObservingOptionNew context:NULL];


    [self customizeCollectionLayout];
    if(self.assetsGroupURL==nil) {
        [self getCameralRollURL];
        
    }else
    {
        [self loadAssets];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}
-(void)dealloc {
    
    [self.dataSource removeObserver:self forKeyPath:@"selectedPhotoNum"];
}
#pragma mark - Target Action
- (IBAction)cancelButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LPCancelButtonDidClickedNotification" object:self userInfo:nil];
}

- (IBAction)previewButtonClicked:(UIButton *)sender {
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"AddPhoto" bundle:nil];
    LPShowFullScreenPhotoViewController *showFullScreenPhotoVC=[storyBoard instantiateViewControllerWithIdentifier:[[LPShowFullScreenPhotoViewController class] description]];
    showFullScreenPhotoVC.dataSource=self.dataSource;
    NSMutableArray *selectedModelArray=[NSMutableArray array];
    for (ChoosePhotoModel *model in self.choosePhotoModelArray) {
        if(model.isSelected){
            [selectedModelArray addObject:model];
        }
    }
    showFullScreenPhotoVC.choosePhotoModelArray=selectedModelArray;
    [self.navigationController pushViewController:showFullScreenPhotoVC animated:YES];
}
- (IBAction)finishButtonClicked:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LPFinishButtonDidClickedNotification" object:nil userInfo:@{@"selectedAssetsURL":[self gernateSelectedAssetsURLArray]}];
}


#pragma mark - Private Method
- (void)customizeCollectionLayout {
    UICollectionViewFlowLayout *layout=(UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    UIScrollView *scrollView=(UIScrollView*)self.collectionView;
    scrollView.contentOffset=CGPointZero;
    layout.itemSize=CGSizeMake(ItemSizeWidth, ItemSizeHeight);
    layout.minimumInteritemSpacing=CellPadding;
    layout.minimumLineSpacing=CellPadding;
}

- (void)loadAssets {
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result!=NULL) {
            
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                
                ChoosePhotoModel *model=[[ChoosePhotoModel alloc]initWithAssetsURL:result.defaultRepresentation.url];
                [self.choosePhotoModelArray addObject:model];
                
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        }
        
    };
    [self.assetslibrary groupForURL:self.assetsGroupURL resultBlock:^(ALAssetsGroup *group) {
        NSString *groupStr=[NSString stringWithFormat:@"%@",group];//获取相簿的组
        NSString *groupStrWithHead=[groupStr substringFromIndex:16 ] ;
        NSArray *arr=[[NSArray alloc] init];
        arr=[groupStrWithHead componentsSeparatedByString:@","];
        NSString *groupName=[[arr objectAtIndex:0] substringFromIndex:5];
        self.title=groupName;
        [group enumerateAssetsUsingBlock:groupEnumerAtion];
    } failureBlock:^(NSError *error) {
    }];
}
-(void)getCameralRollURL{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (group!=nil&&group.numberOfAssets>0) {
                NSString *groupStr=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSString *groupStrWithHead=[groupStr substringFromIndex:16 ] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[groupStrWithHead componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    self.assetsGroupURL=[group valueForProperty:ALAssetsGroupPropertyURL];
                    [self loadAssets];
                    *stop = YES;
                }
            }
        };
        
        [self.assetslibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                          usingBlock:libraryGroupsEnumeration
                                        failureBlock:failureblock];
    });
    
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.choosePhotoModelArray.count;
};

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPChoosePhotoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ChoosePhotoModel *model=self.choosePhotoModelArray[indexPath.row];
    
       [self.assetslibrary assetForURL:model.assetsURL resultBlock:^(ALAsset *asset) {
        UIImage *thumbnailImage=[UIImage imageWithCGImage:asset.thumbnail];
        cell.imageView.image =thumbnailImage;
        cell.selectionButton.selected=model.isSelected;
        __weak __typeof(LPChoosePhotoCell*)weakCell = cell;
           __weak LPChoosePhotoViewController *weakSelf = self;
        cell.selectionButtonClickedBlock=^(){
            BOOL isIllegal=model.isSelected==NO&&[weakSelf.dataSource isSelectedPhotoNumNotLessThanMaxNum];
            if(isIllegal){
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(weakSelf.dataSource.maxSelectedPhotoNum)]  message:nil delegate:weakSelf cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
                return ;
            }
            model.isSelected=!model.isSelected;
            model.latestSelectedTime=[NSDate date];
            NSUInteger count=0;
            for (ChoosePhotoModel *model in weakSelf.choosePhotoModelArray) {
                count=model.isSelected?++count:count;
            }
            weakSelf.dataSource.selectedPhotoNum=@(count);
            weakCell.selectionButton.selected=model.isSelected;
        };
        } failureBlock:nil];
    

    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"AddPhoto" bundle:nil];
    LPShowFullScreenPhotoViewController *showFullScreenPhotoVC=[storyBoard instantiateViewControllerWithIdentifier:[[LPShowFullScreenPhotoViewController class] description]];
    showFullScreenPhotoVC.dataSource=self.dataSource;
    showFullScreenPhotoVC.choosePhotoModelArray=self.choosePhotoModelArray;
    showFullScreenPhotoVC.currentPhotoIndex=indexPath.row;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
                [self.navigationItem setBackBarButtonItem:backButton];
    [self.navigationController pushViewController:showFullScreenPhotoVC animated:YES];
}

#pragma mark - Setter And Getter
- (ALAssetsLibrary *)assetslibrary {
    if(!_assetslibrary) {
        _assetslibrary= [[ALAssetsLibrary alloc]init];
    }
    return _assetslibrary;
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"selectedPhotoNum"])
    {
        if(self.dataSource.selectedPhotoNum.integerValue==0){
            self.selectedPhotoNumBackgroundView.hidden=YES;
            self.selectedPhotoNumLabel.text=@"";
            self.finishButton.enabled=NO;
            self.previewButton.enabled=NO;
            
        }else {
            self.selectedPhotoNumBackgroundView.hidden=NO;
            self.selectedPhotoNumLabel.text=[NSString stringWithFormat:@"%@",self.dataSource.selectedPhotoNum];
            self.finishButton.enabled=YES;
            self.previewButton.enabled=YES;
            [self.selectedPhotoNumBackgroundView animate];
        }
    }
}


@end
