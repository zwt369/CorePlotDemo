//
//  CorePlotView.h
//  CorePlotDemo
//
//  Created by tony on 16/3/8.
//  Copyright © 2016年 YanFa26No2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot.h>


static NSString *const X_AXIS = @"x";
static NSString *const Y_AXIS = @"y";

static NSString *const kDataLine    = @"Data Line";
static NSString *const kDataLineLast = @"Data Line Last";
static NSString *const kDashDataLine = @"Dash Data Line";
static NSString *const kWarningUpLine = @"Warning Up Line";
static NSString *const kWarningLowerLine = @"Warning Lower Line";

@interface CorePlotView : UIView

@property (nonatomic, strong)NSMutableDictionary *plotDatasDictionary;
@property (nonatomic, unsafe_unretained)CGFloat upwarningValue;
@property (nonatomic, unsafe_unretained)CGFloat lowerwarningValue;
- (void)refresh;


@end
