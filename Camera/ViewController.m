//
//  ViewController.m
//  Camera
//
//  Created by 淘饭饭 on 12-12-20.
//  Copyright (c) 2012年 淘饭饭. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imagePicker = _imagePicker;
@synthesize btn = _btn;
@synthesize imageV = _imagev;
- (void)dealloc
{
    [_imagev release];
    [_btn release];
    [_imagePicker release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btn = button;
    [button release];
    self.btn.frame = CGRectMake(50, 50, 100, 40);
    [self.btn setTitle:@"功能" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"460.gif"]];
    self.imageV = iv;
    [iv release];
    self.imageV.frame = CGRectMake(100, 100, 300, 200);
    [self.view addSubview:self.imageV];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showActionSheet
{
    //一个菜单列表 选择照相机还是 相册
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"标题" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"照相",@"相册", nil];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [sheet showInView:[self.view window]];
}

//菜单列表按钮的触发方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//第一个按钮
        //照相机
        [self addOfCamera];
    }
    else//第二个按钮
    {
        //相册
        [self addOfAlbum];
    }
}

- (void) addOfAlbum
{
    //for iphone
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentModalViewController:pickerImage animated:YES];
    [pickerImage release];
    
    /////
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = NO;//是否允许编辑
//    picker.sourceType = sourceType;
//    /*
//     如果从一个导航按钮处呈现，使用：
//     presentPopoverFromBarButtonItem:permittedArrowDirections:animated:；
//     如果要从一个视图出呈现，使用：
//     presentPopoverFromRect:inView:permittedArrowDirections:animated:
//     
//     如果设备旋转以后，位置定位错误需要在父视图控制器的下面方法里面重新定位：
//     didRotateFromInterfaceOrientation:（在这个方法体里面重新设置rect）
//     然后再次调用：
//     - (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated             
//     */
//    //UIPopoverController只能在ipad设备上面使用；作用是用于显示临时内容，特点是总是显示在当前视图最前端，当单击界面的其他地方时自动消失。
//    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
//    self.imagePicker = popover;
//    //permittedArrowDirections 设置箭头方向
//    [self.imagePicker presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    [picker release];
//    [popover release];
}

- (void) addOfCamera
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];//进入照相界面
    [picker release];
}

//把图片添加到当前view中
- (void)saveImage:(UIImage *)image {
    //保存
    self.imageV.image = image;
}
#pragma mark –
#pragma mark Camera View Delegate Methods
//点击相册中的图片或者照相机照完后点击use 后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){//如果打开相册
        [self.imagePicker dismissPopoverAnimated:YES];//关掉相册
        image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    }
    else{//照相机
        [picker dismissModalViewControllerAnimated:YES];//关掉照相机
        image = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    }
    //把选中的图片添加到界面中
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

@end
