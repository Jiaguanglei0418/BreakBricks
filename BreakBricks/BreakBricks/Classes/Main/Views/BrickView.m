//
//  BrickView.m
//  BreakBricks
//
//  Created by jiaguanglei on 15/12/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "BrickView.h"
#import "UIView+Extension.h"
@implementation BrickView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (UIImageView *)brickWithBGImage:(UIImage *)bgImage size:(CGSize)size
{
    UIImageView *brick = [[UIImageView alloc] init];
    brick.size = size;
    brick.image = [bgImage stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
    
    return brick;
}

@end
