//
//  MazeView.m
//  Maze
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Alex Beals. All rights reserved.
//

#import "MazeView.h"

@implementation MazeView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];

    [[NSColor whiteColor] setFill];
    NSRectFill(self.bounds);
    [[NSColor blackColor] set];
    NSString *helloStr = @"hello screen saver plugin";
    [helloStr drawAtPoint:NSMakePoint(100.0, 200.0) withAttributes:nil];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
