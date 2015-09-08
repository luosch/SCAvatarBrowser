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
    
    // scale by pinch on background
    UIPinchGestureRecognizer *pinchOnImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionPinchOnImage:)];
    [background addGestureRecognizer:pinchOnImage];
    
    // move avatar by pan on image
    UIPanGestureRecognizer *panOnImage = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanOnImage:)];
    [newAvatarImageView addGestureRecognizer:panOnImage];
    
    // store avatar image by long press on it
    UILongPressGestureRecognizer *longPressOnImage = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPressOnImage:)];
    longPressOnImage.minimumPressDuration = 0.3f;
    [newAvatarImageView addGestureRecognizer:longPressOnImage];
    
    // show detail view with animation
    [UIView animateWithDuration:0.3f
                     animations:^
    {
        [newAvatarImageView setFrame:CGRectMake(0, top, screenWidth, height)];
        [background setAlpha:1];
    }];
}

// tap to return to original view
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

// pinch to scale the avatar image
+ (void)actionPinchOnImage:(UIPinchGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        currentScale = 1.0f;
        if (newAvatarImageView.frame.size.width < screenWidth) {
            // avatar image too small
            [UIView animateWithDuration:0.5f
                             animations:^
            {
                [newAvatarImageView setCenter:CGPointMake(screenWidth / 2, screenHeight / 2)];
                CGFloat proportion = screenWidth / newAvatarImageView.frame.size.width;
                CGAffineTransform currentTransform = newAvatarImageView.transform;
                CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, proportion, proportion);
                [newAvatarImageView setTransform:newTransform];
            }];
        } else if (newAvatarImageView.frame.size.width > 2 * screenWidth) {
            // avatar image too big
            [UIView animateWithDuration:0.5f
                             animations:^
            {
                CGFloat proportion = 2 * screenWidth / newAvatarImageView.frame.size.width;
                CGAffineTransform currentTransform = newAvatarImageView.transform;
                CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, proportion, proportion);
                [newAvatarImageView setTransform:newTransform];
            }];
        }
        return;
    } else {
        CGFloat proportion = 1.0 - (currentScale - [sender scale]);

        // slow down when being too big or too small
        if (newAvatarImageView.frame.size.width > 2 * screenWidth) {
            proportion = 1.01f;
        } else if (newAvatarImageView.frame.size.width < 0.8 * screenWidth) {
            proportion = 0.99f;
        }
        
        CGAffineTransform currentTransform = newAvatarImageView.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, proportion, proportion);
        
        [newAvatarImageView setTransform:newTransform];
        
        currentScale = [sender scale];
    }
}

// pan to move the avatar image
+ (void)actionPanOnImage:(UIPanGestureRecognizer *)sender {
    if (newAvatarImageView.frame.size.width < screenWidth + 1) {
        return;
    }
    
    CGPoint touchPosition = [sender translationInView:newAvatarImageView];
    CGFloat avatarWidth = newAvatarImageView.frame.size.width;
    CGFloat avatarHeight = newAvatarImageView.frame.size.height;
    CGFloat moveX = touchPosition.x;
    CGFloat moveY = touchPosition.y;
    
    moveX *= (avatarWidth / screenWidth);
    moveY *= (avatarHeight / screenHeight);
    
    
    [sender.view setCenter:CGPointMake(sender.view.center.x + moveX, sender.view.center.y + moveY)];
    [sender setTranslation:CGPointMake(0, 0) inView:newAvatarImageView];
    
    // fix avatar's postion when out of view
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CGFloat newCenterX = screenWidth / 2;
        CGFloat newCenterY = screenHeight / 2;
        BOOL isCenterChanged = NO;
        
        // too left or too right
        if (newAvatarImageView.frame.origin.x + avatarWidth < screenWidth) {
            newCenterX -= (avatarWidth - screenWidth) / 2;
            isCenterChanged = YES;
        } else if (newAvatarImageView.frame.origin.x > 0) {
            newCenterX += (avatarWidth - screenWidth) / 2;
            isCenterChanged = YES;
        } else {
            newCenterX = newAvatarImageView.center.x;
        }
        
        // too top or too bottom
        if (avatarHeight > screenHeight) {
            if (newAvatarImageView.frame.origin.y + avatarHeight < screenHeight) {
                newCenterY -= (avatarHeight - screenHeight) / 2;
                isCenterChanged = YES;
            } else if (newAvatarImageView.frame.origin.y > 0) {
                newCenterY += (avatarHeight - screenHeight) / 2;
                isCenterChanged = YES;
            } else {
                newCenterY = newAvatarImageView.center.y;
            }
        }

        if (isCenterChanged == YES) {
            [UIView animateWithDuration:0.3 animations:^{
                [newAvatarImageView setCenter:CGPointMake(newCenterX , newCenterY)];
            }];
        }
    }
}

// long press to store the avatar
+ (void)actionLongPressOnImage:(UILongPressGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:(id<UIActionSheetDelegate>)self                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"save the picture", nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[sender view]];
    }
}

// select first button to store image
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(newAvatarImageView.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
    }
}

// handle error and success
+ (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        NSLog(@"error");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"fail to store image"
                                                            delegate:nil
                                                   cancelButtonTitle:@"ok"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
    } else {
        NSLog(@"success");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"image has benn stored"
                                                            delegate:nil
                                                   cancelButtonTitle:@"ok"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}

@end
