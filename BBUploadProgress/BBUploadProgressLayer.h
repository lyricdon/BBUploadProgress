//
//  BBUploadProgressLayer.h
//  User
//
//  Created by lyricdon on 16/1/19.
//  Copyright © 2016年 Modern Mobile Digital Media Company Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum
{
    BBUploadProgressStyleRedusedRound,  // (完整圆递减)
    BBUploadProgressStyleCircleProgress, // (圆形进度条)
}BBUploadProgressStyle;

@interface BBUploadProgressLayer : CAShapeLayer

/**
 *  真实进度动画
 *
 *  @param aView      要显示动画的View
 *  @param aProgress  进度
 *  @param aCompleted 回调
 */
- (void)showUploadProgressLayerWithView:(UIView *)aView progress:(NSProgress *)aProgress sytle:(BBUploadProgressStyle)aStyle completed:(void(^)(BOOL success))aCompleted;

/**
 *  模拟进度动画, 自动加载到小于 1/4 就会暂停, 需手动调用 finishAnimation: 结束
 *
 *  @param aView      要显示动画的View
 *  @param aCompleted 回调
 */
- (void)showAutoUploadProgressLayerWithView:(UIView *)aView sytle:(BBUploadProgressStyle)aStyle completed:(void(^)(BOOL success))aCompleted;

/**
 *  手动结束动画
 *
 *  @param success 手动指定是否上传成功, @(1)成功
 */
- (void)finishAnimation:(NSNumber *)success;

@end
