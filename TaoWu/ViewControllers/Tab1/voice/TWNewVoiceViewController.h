//
//  TWNewVoiceViewController.h
//  TaoWu
//
//  Created by JJK on 2023/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWNewVoiceViewController : UIViewController

@end

NS_ASSUME_NONNULL_END




//    // 创建一个圆形雷达波
//    CAShapeLayer *circleLayer = [CAShapeLayer layer];
//    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
//    circleLayer.frame = CGRectMake(0, 0, 200, 200); // 调整大小和位置
//    circleLayer.position = self.view.center;
//    circleLayer.cornerRadius = circleLayer.bounds.size.width / 2.0;
//    circleLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
//    circleLayer.borderWidth = 1.0;
//
//    // 创建渐变层
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = circleLayer.bounds;
//
//    // 定义渐变色的起始颜色和结束颜色
//    UIColor *startColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
//    UIColor *endColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.0];
//    gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
//
//    // 设置渐变色层的方向和位置
//    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
//    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
//    gradientLayer.type = kCAGradientLayerRadial;
////    gradientLayer.radius = sqrt(pow(self.view.bounds.size.width, 2) + pow(self.view.bounds.size.height, 2)) / 2.0;
//
//    // 将渐变层添加到圆形雷达波图层中
//    [circleLayer addSublayer:gradientLayer];
//
//    // 添加到视图的图层中
//    [self.view.layer addSublayer:circleLayer];
//
//    // 创建雷达波动画
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation.fromValue = @(0.0);
//    animation.toValue = @(1.0);
//    animation.duration = 2.0;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//
//    // 创建颜色渐变动画
//    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
//    colorAnimation.fromValue = @[(id)startColor.CGColor, (id)endColor.CGColor];
//    colorAnimation.toValue = @[(id)endColor.CGColor, (id)startColor.CGColor];
//    colorAnimation.duration = 2.0;
//
//    // 创建一个组合动画
//    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//    groupAnimation.animations = @[animation, colorAnimation];
//    groupAnimation.duration = 3.0; // 每个动画循环一次的时间
//    groupAnimation.repeatCount = INFINITY; // 无限循环
//
//    // 将动画添加到雷达波图层中
//    [circleLayer addAnimation:groupAnimation forKey:@"circleAnimation"];
