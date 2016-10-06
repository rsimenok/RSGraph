//
//  RSGraph.m
//  MAA
//
//  Created by Roman Simenok on 8/3/16.
//  Copyright © 2016 Roman Simenok. All rights reserved.
//

#import "RSGraph.h"

@implementation RSGraph

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.lineLayers = [NSMutableArray new];
    }
    
    return self;
}

- (void)draw {
    NSUInteger numberOfLines = [self.delegate numberOfLines];

    NSAssert(numberOfLines != 0, @"Number of lines can't be 0!");
    
    for (NSUInteger i = 0; i<numberOfLines; ++i) {
        CAShapeLayer *layer;
        if (self.lineLayers.count > i) {
            layer = [self.lineLayers objectAtIndex:i];
        } else {
            layer = [self shapeLayerForLine:i];
            [self.lineLayers addObject:layer];
            layer.strokeColor = [self.delegate colorForLine:i].CGColor;
            [self.layer addSublayer:layer];
        }

        UIBezierPath *path = [UIBezierPath bezierPath];
        
        NSArray *_yValuesForLine = [self.delegate yValuesForLine:i];
        NSUInteger numberOfXPoints = _yValuesForLine.count;
        
        BOOL needXPoint = [self.delegate shouldLineGetXCoord:i];
        CGFloat xPointSpace = self.frame.size.width/numberOfXPoints;
        
        for (NSUInteger j = 0; j < _yValuesForLine.count; ++j) {
            CGFloat newx = 0.0;
            if (needXPoint) {
                newx = [self convertAtoBWithValue:[self.delegate valueForXPointAtIndex:j lineID:i] aMin:0 aMax:1 bMin:0 bMax:self.frame.size.width];
            } else {
                newx = xPointSpace*j;
            }
            
            CGFloat y = self.frame.size.height - [self convertAtoBWithValue:[_yValuesForLine[j] floatValue] aMin:0 aMax:1 bMin:0 bMax:self.frame.size.height];
            CGPoint point = CGPointMake(newx, y);
            
            switch (j) {
                case 0:
                    [path moveToPoint:point];
                    break;
                default:
                    [path addLineToPoint:point];
                    break;
            }
        }
        
        layer.path = path.CGPath;
    }
}

- (CGFloat)convertAtoBWithValue:(CGFloat)x aMin:(CGFloat)aMin aMax:(CGFloat)aMax bMin:(CGFloat)bMin bMax:(CGFloat)bMax {
    return MIN(bMin, bMax) + ((x - MIN(aMin, aMax))/fabs(MAX(aMin, aMax) - MIN(aMin, aMax))) * fabs(MAX(bMin, bMax) - MIN(bMin, bMax));
}

- (CAShapeLayer *)shapeLayerForLine:(NSUInteger)lineID {
    CAShapeLayer *item = [CAShapeLayer layer];
    item.fillColor = [self.delegate fillColorForLine:lineID];
    item.lineCap = [self.delegate lineCapforLine:lineID];
    item.lineJoin  = kCALineJoinRound;
    item.lineWidth = [self.delegate strokeWidthForLine:lineID];
    return item;
}

- (void)clear {
    [self.lineLayers removeAllObjects];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

@end
