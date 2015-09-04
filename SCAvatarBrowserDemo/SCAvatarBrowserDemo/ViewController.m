//
//  ViewController.m
//  SCAvatarBrowserDemo
//
//  Created by 罗思成 on 15/9/2.
//  Copyright (c) 2015年 罗思成. All rights reserved.
//

#import "ViewController.h"
#import "SCAvatarBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat avatarWidth = 80.0f;
    CGFloat avatarHeight = 80.0f;
    
    // put a circle image on middle view
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth / 2 - avatarWidth / 2, screenHeight / 2 - avatarHeight / 2 - 40, avatarWidth, avatarHeight)];
    [self.avatar setImage:[UIImage imageNamed:@"cat.jpg"]];
    [self.avatar setUserInteractionEnabled:YES];
    [self.view addSubview:self.avatar];
    
    // to be circle
    [self.avatar.layer setCornerRadius:avatarWidth / 2];
    [self.avatar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.avatar.layer setBorderWidth:1.0f];
    [self.avatar setClipsToBounds:YES];
    
    // create tap event for image
    UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnImage)];
    [self.avatar addGestureRecognizer:tapOnImage];
}

- (void)actionTapOnImage {
    [SCAvatarBrowser showImageView:self.avatar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
