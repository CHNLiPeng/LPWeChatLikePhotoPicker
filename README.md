# LPWeChatLikePhotoPicker
A simple iOS WeChat-Like Photo Picker

##How to use it？

* 1.Drag LPWeChatLikeSelectPhoto Folder into your project.
* 2.#import "LPChoosePhotoViewController.h"
* 3.Write your code like this.
~~~objective-c

LPWeChatLikeSelectePhotoViewController *vc=[[LPWeChatLikeSelectePhotoViewController alloc]initWithMaxPhotoNum:9         finishChoosing:^(NSArray *selectedAssetsURLArray) {
       NSLog(@"%@",selectedAssetsURLArray);
       // Do your custom work.
   }];
    [self presentViewController:vc animated:YES completion:NULL];

~~~

