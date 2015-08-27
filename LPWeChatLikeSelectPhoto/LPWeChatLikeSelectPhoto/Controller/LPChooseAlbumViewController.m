//
//  ChooseAlbumViewController.m
//  CheDingDong
//
//  Created by lipeng on 15/8/18.
//  Copyright (c) 2015年 Riley. All rights reserved.
//

#import "LPChooseAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LPChooseAlbumCell.h"
#import "LPChoosePhotoViewController.h"
static NSString *identifier=@"LPChooseAlbumCell";

@interface LPChooseAlbumViewController ()
@property (nonatomic,strong) NSMutableArray *assetsGroupURLArray;
@property (nonatomic,strong) ALAssetsLibrary *library;
@end

@implementation LPChooseAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.assetsGroupURLArray=[NSMutableArray array];
    self.library = [[ALAssetsLibrary alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getImgs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Target Action
- (IBAction)cancelButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LPCancelButtonDidClickedNotification" object:self userInfo:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.assetsGroupURLArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPChooseAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self.library groupForURL:self.assetsGroupURLArray[indexPath.row] resultBlock:^(ALAssetsGroup *group) {
        cell.posterImageView.image=[UIImage imageWithCGImage:group.posterImage];
        cell.nameLabel.text=[group valueForProperty:ALAssetsGroupPropertyName];
        cell.assetsCountLabel.text=[NSString stringWithFormat:@"(%@)",@(group.numberOfAssets)];
    } failureBlock:^(NSError *error) {
        
    }];
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *addPhotoStoryBoard=[UIStoryboard storyboardWithName:@"AddPhoto" bundle:nil];
    LPChoosePhotoViewController *choosePhtoViewController =(LPChoosePhotoViewController*)
    [addPhotoStoryBoard instantiateViewControllerWithIdentifier:[[LPChoosePhotoViewController class] description]];
    choosePhtoViewController.assetsGroupURL = self.assetsGroupURLArray[indexPath.row];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [self.navigationController pushViewController:choosePhtoViewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)getImgs{
    
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
                NSURL *groupURL=[group valueForProperty:ALAssetsGroupPropertyURL];
                    [self.assetsGroupURLArray addObject:groupURL];
            }else {
                [self.tableView reloadData];
            }
        };
        
       
        [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
    
}


@end
