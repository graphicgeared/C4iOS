//
//  C4ShapeLayer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeLayer.h"
@interface C4ShapeLayer() 
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath;
@end

@implementation C4ShapeLayer
@synthesize animationOptions = _animationOptions, currentAnimationEasing, repeatCount;
@synthesize allowsInteraction, repeats;

-(id)init {
    self = [super init];
    if(self != nil) {
        currentAnimationEasing = kCAMediaTimingFunctionDefault;
        allowsInteraction = NO;
        repeats = NO;
        self.animationDurationValue = 0.0f;
        self.repeatCount = 0;
        self.autoreverses = NO;
        self.fillMode = kCAFillModeBoth;
        self.strokeEnd = 1.0f;
        self.strokeStart = 0.0f;
        /* create basic attributes after setting animation attributes above */
        self.path = CGPathCreateWithRect(CGRectZero, nil);
        self.fillColor = [UIColor blueColor].CGColor;
        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
    }
    return self;
}

-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = [[self valueForKey:kCATransactionAnimationDuration] doubleValue];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:self.currentAnimationEasing];
    animation.autoreverses = self.autoreverses;
    animation.repeatCount = self.repeats ? FOREVER : 0;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = YES;
    return animation;
}

/* encapsulating an animation that will correspond to the superview's animation */
-(void)setPath:(CGPathRef)newPath {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"path"];
    [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id)self.path;
    animation.toValue = (__bridge id)newPath;    
    [self addAnimation:animation forKey:@"animatePath"];
    if(!self.autoreverses) [super setPath:newPath];
}

-(void)setFillColor:(CGColorRef)_fillColor { 
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"fillColor"];
    animation.fromValue = (id)self.fillColor;
    animation.toValue = (__bridge id)_fillColor;   
    [self addAnimation:animation forKey:@"animateFillColor"];
    if(!self.autoreverses) [super setFillColor:_fillColor];
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = [NSNumber numberWithFloat:self.lineDashPhase];
    animation.toValue = [NSNumber numberWithFloat:_lineDashPhase];
    [self addAnimation:animation forKey:@"animateLineDashPhase"];
    if(!self.autoreverses) [super setLineDashPhase:_lineDashPhase];
}

-(void)setLineWidth:(CGFloat)_lineWidth {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineWidth"];
    animation.fromValue = [NSNumber numberWithFloat:self.lineWidth];
    animation.toValue = [NSNumber numberWithFloat:_lineWidth];
    [self addAnimation:animation forKey:@"animateLineWidth"];
    if(!self.autoreverses) [super setLineWidth:_lineWidth];
}

-(void)setMitreLimit:(CGFloat)_mitreLimit {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"mitreLimit"];
    animation.fromValue = [NSNumber numberWithFloat:self.miterLimit];
    animation.toValue = [NSNumber numberWithFloat:_mitreLimit];
    [self addAnimation:animation forKey:@"animateMitreLimit"];
    if(!self.autoreverses) [super setMiterLimit:_mitreLimit];
}

-(void)setStrokeColor:(CGColorRef)_strokeColor {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeColor"];
    animation.fromValue = (id)self.strokeColor;
    animation.toValue = (__bridge id)_strokeColor;   
    [self addAnimation:animation forKey:@"animateStrokeColor"];
    if(!self.autoreverses) [super setStrokeColor:_strokeColor];
}

-(void)setStrokeEnd:(CGFloat)_strokeEnd {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:self.strokeEnd];
    animation.toValue = [NSNumber numberWithFloat:_strokeEnd];  
    [self addAnimation:animation forKey:@"animateStrokeEnd"];
    if(!self.autoreverses) [super setStrokeEnd:_strokeEnd];
}

-(void)setStrokeStart:(CGFloat)_strokeStart {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeStart"];
    animation.fromValue = [NSNumber numberWithFloat:self.strokeStart];
    animation.toValue = [NSNumber numberWithFloat:_strokeStart];  
    [self addAnimation:animation forKey:@"animateStrokeStart"];
    if(!self.autoreverses) [super setStrokeStart:_strokeStart];
}

-(void)setAnimationDurationValue:(CGFloat)duration {
    if (duration <= 0.0f) duration = 0.001f;
    [self setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
}

-(CGFloat)animationDurationValue {
    return [[self valueForKey:kCATransactionAnimationDuration] floatValue];
}

/* in the following method
 if we implement other kinds of options, we'll have to get rid of the returns...
 (i.e. the ones which are outlined in C4AnimationOptions, in C4Defines.h) 
 was doing shit like the following, and it wasn't working:
    mask = LINEAR;
    C4Log(@"--- EASEIN --- %d", mask);
    if((mask & EASEIN) == EASEIN) C4Log(@"EASEIN");
    if((mask & EASEINOUT) == EASEINOUT) C4Log(@"EASEINOUT");
    if((mask & EASEOUT) == EASEOUT) C4Log(@"EASEOUT");
    if((mask & LINEAR) == LINEAR) C4Log(@"LINEAR");
 */

//reversing how i check the values, if linear is at the bottom, then all the other values get called
-(void)setAnimationOptions:(NSUInteger)animationOptions {
    if((animationOptions & LINEAR) == LINEAR) {
        currentAnimationEasing = kCAMediaTimingFunctionLinear;
    } else if((animationOptions & EASEOUT) == EASEOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseOut;
    } else if((animationOptions & EASEIN) == EASEIN) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseIn;
    } else if((animationOptions & EASEINOUT) == EASEINOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    } else {
        currentAnimationEasing = kCAMediaTimingFunctionDefault;
    }
    
    if((animationOptions & AUTOREVERSE) == AUTOREVERSE) self.autoreverses = YES;
    else self.autoreverses = NO;
    
    if((animationOptions & REPEAT) == REPEAT) repeats = YES;
    else repeats = NO;
    
    if((animationOptions & ALLOWSINTERACTION) == ALLOWSINTERACTION) allowsInteraction = YES;
    else allowsInteraction = NO;
}

-(void)test {
    C4Log(@"animationOptions: %@",self.currentAnimationEasing);
    C4Log(@"autoreverses: %@", self.autoreverses ? @"YES" : @"NO");
}

@end