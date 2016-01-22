//
//  ViewController.m
//  BBUploadProgress
//
//  Created by lyricdon on 16/1/19.
//  Copyright © 2016年 lyricdon. All rights reserved.
//

#import "ViewController.h"
#import "BBUploadProgressLayer.h"
@interface ViewController ()
{
    void (^completedBlock) (BOOL success);
    BBUploadProgressLayer *shapeLayer;
    NSProgress *progress;
    NSTimer *timer;
}


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

int count = 0;

@implementation ViewController

// 真实progress效果展示
- (IBAction)successUpload {
    [self.imgView setImage:[UIImage imageNamed:@"uploadPic"]];
    shapeLayer = [BBUploadProgressLayer layer];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [shapeLayer showUploadProgressLayerWithView:self.imgView progress:progress sytle:BBUploadProgressStyleRedusedRound completed:completedBlock];
}

// 假动画失败效果展示
- (IBAction)failureUpload {
    [self.imgView setImage:[UIImage imageNamed:@"uploadPic"]];
    shapeLayer = [BBUploadProgressLayer layer];
    [shapeLayer showAutoUploadProgressLayerWithView:self.imgView sytle:BBUploadProgressStyleRedusedRound completed:completedBlock];
    [shapeLayer performSelector:@selector(finishAnimation:) withObject:@(0) afterDelay:5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    completedBlock = ^(BOOL success){
        if (success) {
            NSLog(@"成功! 保存新头像");
        }else {
            NSLog(@"失败! 切换回原始头像");
            [weakSelf.imgView setImage:[UIImage imageNamed:@"prePic"]];
        }
    };
    
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width * 0.5;
    self.imgView.layer.masksToBounds = YES;
    
    count = 0;
    progress = [NSProgress progressWithTotalUnitCount:100];
    
}

- (void)updateProgress
{
    if (count == 100) {
        count = 0;
        [timer invalidate];
        return;
    }
    
    count++;
    [progress setCompletedUnitCount:count];
    
    NSLog(@"%f",progress.fractionCompleted);
}

@end
