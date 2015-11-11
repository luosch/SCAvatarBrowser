SCAvatarBrowser
============
## Overview

`SCAvatarBrowser` is a slight and powerful tool to recreate the view used to enlarge photos from their avatar previews.

By using `SCAvatarBrowser`, you can make your avatar scalable, draggable and storable within just one line.

    [SCAvatarBrowser showImage:self.avatar];

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

- ~~Create one example~~ (added 2015/09/04)
- ~~Support for drag and sacle~~ (added 2015/09/08)
- ~~Support for store image to local photo library~~ (added 2015/09/08)
- ~~Add CocoaPods spec~~ (added 2015/11/11)

## License

This code is distributed under the terms and conditions of the MIT license.