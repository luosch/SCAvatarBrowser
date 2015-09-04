//
//  SCAvatarBrowser.m
//  SCAvatarBrowserDemo
//
//  Created by 罗思成 on 15/9/3.
//  Copyright (c) 2015年 罗思成. All rights reserved.
//

#import "SCAvatarBrowser.h"

static CGRect avatarFrame;
static UIImageView *newAvatarImageView;
static CGFloat currentScale;
static CGFloat screenWidth;
static CGFloat screenHeight;

@implementation SCAvatarBrowser

+ (void)showImageView:(UIImageView *)avatarImageView {
    if (avatarImageView == nil) {
        NSLog(@"avatarImageView is nil");
        return;
    }
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIImage *avatarImage = [avatarImageView image];
    
    // black background contains the avatar image
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [background setBackgroundColor:[UIColor blackColor]];
    [background setAlpha:0];

    // same size of original image
    avatarFrame = [avatarImageView convertRect:avatarImageView.bounds toView:keyWindow];
    newAvatarImageView = [[UIImageView alloc] initWithFrame:avatarFrame];
    [newAvatarImageView setImage:avatarImage];
    [newAvatarImageView setUserInteractionEnabled:YES];
    [background addSubview:newAvatarImageView];
    [keyWindow addSubview:background];
    
    // make it show on middle
    CGFloat proportion = screenWidth / avatarImage.size.width;
    CGFloat top = screenHeight / 2 - avatarImage.size.height * proportion / 2;
    CGFloat height = avatarImage.size.height * proportion;
    
    // return to origin view by tap on background
    UITapGestureRecognizer *tapOnBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnImage:)];
    [background addGestureRecognizer:tapOnBackground];
    
    // scale up or down by pinch on background
    UIPinchGestureRecognizer *pinchOnImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionPinchOnImage:)];
    [background addGestureRecognizer:pinchOnImage];
    
    // show detail view with animation
    [UIView animateWithDuration:0.3f
                     animations:^
    {
        [newAvatarImageView setFrame:CGRectMake(0, top, screenWidth, height)];
        [background setAlpha:1];
    }];
}

+ (void)actionTapOnImage:(UITapGestureRecognizer *)sender {
    UIView *background = [sender view];
    [UIView animateWithDuration:0.3f animations:^ {
        [newAvatarImageView setFrame:avatarFrame];
        [background setAlpha:0];
    } completion:^(BOOL finished) {
        [background removeFromSuperview];
        newAvatarImageView = nil;
    }];
}

+ (void)actionPinchOnImage:(UIPinchGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (newAvatarImageView.frame.size.width < screenWidth) {
            [UIView animateWithDuration:0.5f
                             animations:^
            {
                [newAvatarImageView setCenter:CGPointMake(screenWidth / 2, screenHeight / 2)];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
