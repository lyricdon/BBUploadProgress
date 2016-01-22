//
//  BBUploadProgressLayer.m
//  User
//
//  Created by lyricdon on 16/1/19.
//  Copyright © 2016年 Modern Mobile Digital Media Company Limited. All rights reserved.
//

#import "BBUploadProgressLayer.h"

@interface BBUploadProgressLayer ()
{
    BBUploadProgressStyle currentStyel;
    NSTimer *timer;
    CGFloat startAngle, endAngle, autoAdd;
    UIView *theView;
    void(^completed)(BOOL success);
}

@property (nonatomic, strong) NSProgress *progress;

@end

@implementation BBUploadProgressLayer

- (void)finishAnimation:(NSNumber *)success
{
    if (success.intValue == 1) {
        if (completed) {
            completed(YES);
        }
    }
    else {
        if (completed) {
            completed(NO);
        }
    }
    [timer invalidate];
    [self removeFromSuperlayer];
}

- (void)showAutoUploadProgressLayerWithView:(UIView *)aView sytle:(BBUploadProgressStyle)aStyle completed:(void (^)(BOOL))aCompleted
{
    [self showUploadProgressLayerWithView:aView progress:nil sytle:aStyle completed:aCompleted];
}

- (void)showUploadProgressLayerWithView:(UIView *)aView progress:(NSProgress *)aProgress sytle:(BBUploadProgressStyle)aStyle completed:(void (^)(BOOL))aCompleted
{
    theView = aView;
    completed = aCompleted;
    self.progress = aProgress;
    autoAdd = 0;
    currentStyel = aStyle;
    
    self.frame = aView.bounds;
    [aView.layer addSublayer:self];
    
    switch (aStyle) {
        
        case BBUploadProgressStyleRedusedRound:
        {
            [self setupRedusedRound];
        }
            break;
            
        case BBUploadProgressStyleCircleProgress:
        {
            [self setupCircleProgress];
        }
            break;
   
        default:
            break;
    }
}


#pragma mark Initial

- (void)setupRedusedRound
{
    self.fillColor = [UIColor colorWithWhite:0.2 alpha:0.4].CGColor;
    startAngle = - M_PI_2;
    endAngle = 3 * M_PI_2;
    
    if (_progress != nil) {
        startAngle = - M_PI_2 + M_PI * _progress.fractionCompleted;
        endAngle = 3 * M_PI_2 - M_PI * _progress.fractionCompleted;
        
        [self drawTheRedusedRound];

    }else {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                 target:self
                                               selector:@selector(animationWithRedusedRound)
                                               userInfo:nil
                                                repeats:YES];
    }
    
}

- (void)setupCircleProgress
{
    
}

#pragma mark privateMethods

// 模拟动画
- (void)animationWithRedusedRound
{
    CGFloat random = arc4random_uniform(10) / 20.0;
    autoAdd = asin(random);
    startAngle += autoAdd;
    endAngle -= autoAdd;
    
    [self drawTheRedusedRound];

    if (startAngle >= M_PI_2 * 0.5 || endAngle <= M_PI_2 * 1.5) {
        [timer invalidate];
        return;
    }
}

- (void)drawTheRedusedRound
{
    CGFloat radius = theView.bounds.size.width * 0.5;
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:startAngle  endAngle: endAngle clockwise:YES];
    self.path = roundPath.CGPath;
}


// 圆形的边
- (void)drawTheCircleLineAround
{
    
}

// 真实进度
- (void)setProgress:(NSProgress *)progress
{
    if (progress == nil) {
        return;
    }
    _progress = progress;

    [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        
        if (_progress.fractionCompleted == 1) {
            if (completed) {
                completed(YES);
            }
            [_progress removeObserver:self forKeyPath:@"fractionCompleted"];
            [self removeFromSuperlayer];
        }else {
            startAngle = - M_PI_2 + _progress.fractionCompleted * M_PI;
            endAngle = 3 * M_PI_2 - _progress.fractionCompleted * M_PI;
            [self drawTheRedusedRound];
        }
    }
}

@end
