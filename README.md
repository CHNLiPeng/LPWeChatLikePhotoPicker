# LPWeChatLikePhotoPicker
A simple iOS WeChat-Like Photo Picker

##How to use it？

*1.Drag LPWeChatLikeSelectPhoto Folder into your project.
*2.#import "LPChoosePhotoViewController.h"
3.
~~~objective-c

LPWeChatLikeSelectePhotoViewController *vc=[[LPWeChatLikeSelectePhotoViewController alloc]initWithMaxPhotoNum:9         finishChoosing:^(NSArray *selectedAssetsURLArray) {
       NSLog(@"%@",selectedAssetsURLArray);
   }];
    [self presentViewController:vc animated:YES completion:NULL];

~~~

