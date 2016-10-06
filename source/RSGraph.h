//
//  RSGraph.h
//  MAA
//
//  Created by Roman Simenok on 8/3/16.
//  Copyright © 2016 Roman Simenok. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSGraphDelegate <NSObject>

- (NSUInteger)numberOfLines;
- (UIColor *)colorForLine:(NSUInteger)index;
- (NSArray *)yValuesForLine:(NSUInteger)index;
- (BOOL)shouldLineGetXCoord:(NSUInteger)lineID;

@optional

- (NSString *)lineCapforLine:(NSUInteger)lineID;
- (CGFloat)strokeWidthForLine:(NSUInteger)lineID;
- (CGColorRef)fillColorForLine:(NSUInteger)lineID;
- (CGFloat)valueForXPointAtIndex:(NSUInteger)index lineID:(NSUInteger)lineID;

@end

@interface RSGraph : UIView

@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *lineLayers;
@property (weak, nonatomic) IBOutlet id<RSGraphDelegate> delegate;

- (void)draw;
- (void)clear;

@end
