//
//  TCountdown.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 21.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TCountdown.h"
#import "TAddCamBaseViewController.h"

@interface TCountdown (){
    
}
@property (nonatomic, assign) NSTimeInterval startTS;
@property (nonatomic, assign) NSTimeInterval timeLeft;
@property (nonatomic, assign) NSTimeInterval progress;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TCountdown

- (void)dealloc{
    [self stop];
}

#pragma mark- timer
- (void)start{
    [self stop];
    self.timer = [NSTimer timerWithTimeInterval:1/30. target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    self.startTS = CACurrentMediaTime();
    self.progress = 1;
    self.timeLeft = 0;
    [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stop{
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)isStarted{
    return self.timer.isValid;
}

- (void)timerTick:(NSTimer*)timer{
    self.timeLeft = MAX(0, CACurrentMediaTime() - self.startTS);
}

- (void)setTimeLeft:(NSTimeInterval)timeLeft{
    if (_timeLeft != timeLeft){
        _timeLeft = MAX(0, timeLeft);
        self.progress = MAX(0, 1 - timeLeft / self.totalTime);
        self.label.text = [NSString stringWithFormat:@"%.0f%@", self.totalTime - timeLeft, LSTR(@"sec-shortness")];
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(NSTimeInterval)progress{
    if (_progress != progress){
        _progress = progress;
        if (progress <= 0){
            [self stop];
            [self.delegate countdownTimeIsOut:self];
        }
    }
}

#pragma mark- draw
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // rounded background
    [self.lineBackgroundColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect:self.bounds] fill];
    
    // clockwise path
    const CGFloat startAngle = -M_PI_2;
    const CGFloat activeAngle = 2 * M_PI * self.progress - M_PI_2;
    const CGPoint bcenter = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
    UIBezierPath *activePath = [UIBezierPath bezierPathWithArcCenter:bcenter
                                                              radius:CGRectGetWidth(self.bounds) / 2 - 6
                                                          startAngle:startAngle
                                                            endAngle:activeAngle
                                                           clockwise:YES];
    activePath.lineJoinStyle = kCGLineJoinRound;
    activePath.lineCapStyle = kCGLineCapRound;
    activePath.lineWidth = 4;
    [self.lineColor setStroke];
    [activePath stroke];
}
@end
