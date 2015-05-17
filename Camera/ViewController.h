//
//  ViewController.h
//  Camera
//
//  Created by 淘饭饭 on 12-12-20.
//  Copyright (c) 2012年 淘饭饭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>

@property (retain,nonatomic)UIPopoverController *imagePicker;
@property (retain,nonatomic)UIButton *btn;
@property (retain,nonatomic)UIImageView *imageV;
- (void)showActionSheet;
@end
