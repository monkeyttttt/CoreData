//
//  ViewController.m
//  CoreDataTest
//
//  Created by ding on 15/10/14.
//  Copyright (c) 2015年 aoyolo.com. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "User.h"
@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *userIdTextField;
@property (strong, nonatomic) IBOutlet UIButton *userBtn;
@property(nonatomic,copy)UIImage *chooseImg;
@end

@implementation ViewController
- (IBAction)chooseHeader:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册中选择" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}
- (IBAction)save:(id)sender {
    if (self.chooseImg!=nil) {
        DBManager *manager=[DBManager shareDBManager];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"userId=%@",self.userIdTextField.text];
        //选查询满足条件的记录是否存在，不存在就可以添加
        NSUInteger count=[manager excuteQueryCountWithEntityName:@"User" predicates:predicate];
        if (count==0) {
            User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:manager.managedObjectContext];
            [user setUserId:@(self.userIdTextField.text.intValue)];
            [user setName:self.userNameTextField.text];
            [user setAge:@(self.ageTextField.text.intValue)];
            [user setHeaderImg:UIImagePNGRepresentation(self.chooseImg)];
            if ([manager excuteInsertOrUpdateManagedObj:user]) {
                [self showPrompt:@"插入成功"];
                self.userNameTextField.text=nil;
                self.userIdTextField.text=nil;
                self.ageTextField.text=nil;
                [self.userBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [self.userBtn setTitle:@"点击选择头像" forState:UIControlStateNormal];
            }else{
                [self showPrompt:@"插入失败"];
            }
        }else{
            [self showPrompt:@"存在用户ID相同的用户"];
        }
       
    }
}

-(void)showPrompt:(NSString *)str
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        //UIImagePickerControllerSourceTypePhotoLibrary代表相册
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
    }else if(buttonIndex==1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker=[[UIImagePickerController alloc] init];
            picker.delegate=self;
            //UIImagePickerControllerSourceTypeCamera代表相机
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];

        }else{
            [self showPrompt:@"不能调用设备"];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img=[[info objectForKey:UIImagePickerControllerEditedImage] copy];
    self.chooseImg=img;
    [self.userBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.userBtn setTitle:@"点击更改图片" forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
