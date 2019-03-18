//
//  CYCircularSlider.m
//  CYCircularSlider
//
//  Created by user on 2018/3/23.
//  Copyright © 2018年 com. All rights reserved.
//

#import "CYCircularSlider.h"

#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
@implementation CYCircularSlider{
    int _angle;
    CGFloat radius;
    int _fixedAngle;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _maximumValue = 14.0f;
        _minimumValue = 0.0f;
        _currentValue = 0.0f;
        _lineWidth = 5.0f;
        _unfilledColor = [UIColor colorWithRed:250/255.0f green:60/255.0f blue:20/255.0f alpha:1.0f];
        _filledColor = [UIColor colorWithRed:175/255.0f green:195/255.0f blue:5/255.0f alpha:1.0f];
        radius = self.frame.size.height/2 - _lineWidth/2-10;
        _angle = 400;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return  self;
}

#pragma mark 画圆
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //画固定的下层圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI/180*140, M_PI/180*40, 0);
    [_unfilledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI/180*140, M_PI/180*(_angle), 0);
   //画可滑动的上层圆
    [_filledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    [self drawHandle:ctx];
}

#pragma mark 画按钮
-(void)drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle: _angle];
    [_handleColor set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-2.5, handleCenter.y-2.5, _lineWidth+5, _lineWidth+5));
    CGContextRestoreGState(ctx);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt)));
    
    return result;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
 
    //用于排除点在圆外面点与圆心半径80以内的点
    if ((lastPoint.x>=0&&lastPoint.x<=275)&&(lastPoint.y>=0 && lastPoint.y<=275)) {
        
        if ((lastPoint.x<=57.5 ||lastPoint.x>=217.5)||(lastPoint.y<=57.5 ||lastPoint.y>=217.5)) {
            [self moveHandle:lastPoint];
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));
    if (currentAngle>40 && currentAngle <140) {
    }else{
        if (currentAngle<=40) {
            _angle = currentAngle+360;
        }else{
            _angle = currentAngle;
        }
        
    }
    _currentValue =[self valueFromAngle];
    [self setNeedsDisplay];
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

//在这个地方调整进度条
-(float) valueFromAngle {
    if(_angle <= 40) {
        _currentValue = 220+_angle;
    } else if(_angle>40 && _angle < 140){
        
    }else{
        _currentValue = _angle-100-40;
    }
    _fixedAngle = _currentValue;

    return (_currentValue*(_maximumValue - _minimumValue))/260.0f;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    [self.delegate senderVlueWithNum:(int8_t)roundf(_currentValue)];
}

#pragma mark 设置进度条位置
-(void)setAngel:(int)num{
    _angle = num;
    [self setNeedsDisplay];
}

-(void)setAddAngel{
    _angle += (int)260/(_maximumValue - _minimumValue);
    if (_angle>400) {
        _angle = 400;
    }
    [self setNeedsDisplay];
}

-(void)setMovAngel{
    _angle -= (int)260/(_maximumValue - _minimumValue);
    if (_angle<140) {
        _angle = 140;
    }
    [self setNeedsDisplay];
}




@end
