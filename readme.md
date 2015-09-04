SCAvatarBrowser
============
## Overview

`SCAvatarBrowser` is a slight and powerful tool to recreate the view used to enlarge photos from their avatar previews.

By using `SCAvatarBrowser`, you can make your avatar scalable, draggable and storable within just one line.

    [SCAvatarBrowser showImage:[UIImage imageNamed:@"myAvatar.jpg"] fromView:self.view];

## Installation

To use `SCAvatarBrowser` in your own project, just import `SCAvatarBrowser.h` and `SCAvatarBrowser.m` files into your project, and then include "`SCAvatarBrowser.h`" where needed, or in your precompiled header.

The project uses ARC and targets iOS 7.0+.

## Usage Examples

	#import "SCAvatarBrowser.h"
	...
	...
	...
	- (void)showAvatarDetalView {
	    [SCAvatarBrowser showImageView:self.avatar];
	}

## TODO

- ~~Create one example~~
- Support for drag and sacle
- Support for store image to local photo library
- Add CocoaPods spec

## License

This code is distributed under the terms and conditions of the MIT license.