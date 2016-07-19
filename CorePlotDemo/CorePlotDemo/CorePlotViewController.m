//
//  CorePlotViewController.m
//  CorePlotDemo
//
//  Created by tony on 16/3/7.
//  Copyright © 2016年 YanFa26No2. All rights reserved.
//

#import "CorePlotViewController.h"


@interface CorePlotViewController ()<CPTPlotDataSource,CPTAxisDelegate>

@property(nonatomic,strong)CPTGraphHostingView *hostingView;
@property(nonatomic,strong)CPTXYGraph *graph;
@property(nonatomic,strong)NSMutableArray *dataForPlot;


@end


@implementation CorePlotViewController


-(void)loadView{

    [super loadView];
    
    _hostingView = [[CPTGraphHostingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _hostingView;
    
}



-(void)viewDidLoad{

    [super viewDidLoad];
    [self setupCoreplotViews];
}


- (void)setupCoreplotViews
{
    //创建了一个可编辑的线条风格 lineStyle，用来描述描绘线条的宽度，颜色和样式等
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题 创建基于 xy 轴的图：CPTXYGraph，并设置其主题 CPTTheme，CorePlot 中的主题和日常软件中的换肤概念差不多。kCPTDarkGradientTheme, kCPTPlainBlackTheme, kCPTPlainWhiteTheme, kCPTSlateTheme,kCPTStocksTheme,
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.view;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    //设置边距
    _graph.paddingLeft = _graph.paddingRight = 70.0;
    _graph.paddingTop = _graph.paddingBottom = 70.0;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
   // plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:10]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0]length:[NSNumber numberWithFloat:10]];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
   // lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalPosition = [NSNumber numberWithFloat:0];
//    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2"); // 原点的 x 位置
    x.majorIntervalLength = [NSNumber numberWithFloat:1];   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 1;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    x.title = @"x轴";
    x.titleLocation = [NSNumber numberWithFloat:7.5];
    x.titleOffset = 30;
    // 需要排除的不显示数字的主刻度
//    NSArray * exclusionRanges = [NSArray arrayWithObjects:
//                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
//                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
//                                 nil];
//    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalPosition = [NSNumber numberWithFloat:0];
//    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2"); // 原点的 y 位
    y.majorIntervalLength = [NSNumber numberWithFloat:1];   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 1;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
//    exclusionRanges = [NSArray arrayWithObjects:
//                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
//                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
//                       nil];
//    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    y.title = @"y轴";
      y.titleOffset = 30.0f;
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier = @"Blue Plot";
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
//    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    //CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
   // CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor endingColor:redColor];
//    areaGradient1.angle = -90.0f;
//    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
//    boundLinePlot.areaFill      = areaGradientFill;
//    boundLinePlot.areaBaseValue = [NSNumber numberWithFloat:1]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
//    lineStyle                = [CPTMutableLineStyle lineStyle];
//    lineStyle.lineWidth      = 3.f;
//    lineStyle.lineColor      = [CPTColor greenColor];
//    lineStyle.dashPattern    = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f],[NSNumber numberWithFloat:5.0f], nil];
//    CPTScatterPlot * dataSourceLinePlot = [[CPTScatterPlot alloc] init];
//    dataSourceLinePlot.dataLineStyle = lineStyle;
//    dataSourceLinePlot.identifier = @"Green Plot";
//    dataSourceLinePlot.dataSource = self;
    
    // Put an area gradient under the plot above
    //
//    CPTColor * areaColor            = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
//    CPTGradient * areaGradient      = [CPTGradient gradientWithBeginningColor:areaColor
//                                                                  endingColor:[CPTColor clearColor]];
//    areaGradient.angle              = -90.0f;
//    areaGradientFill                = [CPTFill fillWithGradient:areaGradient];
//    dataSourceLinePlot.areaFill     = areaGradientFill;
//    dataSourceLinePlot.areaBaseValue= [NSNumber numberWithFloat:1.75];
    
    // Animate in the new plot: 淡入动画
//    dataSourceLinePlot.opacity = 0.0f;
    
//    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeInAnimation.duration            = 3.0f;
//    fadeInAnimation.removedOnCompletion = NO;
//    fadeInAnimation.fillMode            = kCAFillModeForwards;
//    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
//    [dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
//    
//    [_graph addPlot:dataSourceLinePlot];
    
    // Add some initial data
    //
    _dataForPlot = [[NSMutableArray alloc]init];
   
    NSUInteger i;
    for ( i = 0; i < 10; i++ ) {
        id x = [NSNumber numberWithFloat:(0 + i *2) ];
        id y = [NSNumber numberWithFloat:1 * rand() / (float)RAND_MAX + 1.2];
        [_dataForPlot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
}

//-(void)changePlotRange
//{
//    // Change plot space
//    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
//    
//    plotSpace.xRange = [self CPTPlotRangeFromFloat:0.0 length:(3.0 + 2.0 * rand() / RAND_MAX)];
//    plotSpace.yRange = [self CPTPlotRangeFromFloat:0.0 length:(3.0 + 2.0 * rand() / RAND_MAX)];
//}

//-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
//{
//    return [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:location] length:[NSNumber numberWithFloat:length]];
//}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber * num = [[_dataForPlot objectAtIndex:index] valueForKey:key];

    // Green plot gets shifted above the blue
//    if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"]) {
//        if (fieldEnum == CPTScatterPlotFieldY) {
//            num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
//        }
//    }
    
    return num;
}

#pragma mark -
#pragma mark Axis Delegate Methods

//-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
//{
//    static CPTTextStyle * positiveStyle = nil;
//    static CPTTextStyle * negativeStyle = nil;
//    
//    NSNumberFormatter * formatter   = axis.labelFormatter;
//    CGFloat labelOffset             = axis.labelOffset;
//    NSDecimalNumber * zero          = [NSDecimalNumber zero];
//    
//    NSMutableSet * newLabels        = [NSMutableSet set];
//    
//    for (NSDecimalNumber * tickLocation in locations) {
//        CPTTextStyle *theLabelTextStyle;
//        
//        if ([tickLocation isGreaterThanOrEqualTo:zero]) {
//            if (!positiveStyle) {
//                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
//                newStyle.color = [CPTColor greenColor];
//                positiveStyle  = newStyle;
//            }
//            
//            theLabelTextStyle = positiveStyle;
//        }
//        else {
//            if (!negativeStyle) {
//                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
//                newStyle.color = [CPTColor redColor];
//                negativeStyle  = newStyle;
//            }
//            
//            theLabelTextStyle = negativeStyle;
//        }
//        
//        NSString * labelString      = [formatter stringForObjectValue:tickLocation];
//        CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
//        
//        CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
//        //newLabel.tickLocation   = tickLocation.decimalValue;
//        newLabel.offset             = labelOffset;
//        
//        [newLabels addObject:newLabel];
//    }
//    
//    axis.axisLabels = newLabels;
//    
//    return NO;
//}



/*

-(void)loadView{

    [super loadView];
    self.view.backgroundColor = [UIColor orangeColor];
//    _hostingView = [[CPTGraphHostingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.view = _hostingView;
}



-(void)viewDidLoad{

    [super viewDidLoad];
    

}

-(void)viewWillAppear:(BOOL)animated{

    self.graph = [[CPTXYGraph alloc]initWithFrame:CGRectZero];
    //指定主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.graph applyTheme:theme];
    
    self.view = [[CPTGraphHostingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    CPTGraphHostingView *hostView = (CPTGraphHostingView *)self.view;
    [hostView setHostedGraph:self.graph];
    
    //边框 ：无
    self.graph.plotAreaFrame.borderLineStyle = nil;
    self.graph.plotAreaFrame.cornerRadius = 0;
    
    //CPTXYGraph 四边不留白
    self.graph.paddingBottom = self.graph.paddingLeft = self.graph.paddingRight = self.graph.paddingTop = 0;
    
    //绘图区留白
    self.graph.plotAreaFrame.paddingTop = self.graph.plotAreaFrame.paddingBottom = 70.0;
    self.graph.plotAreaFrame.paddingLeft = self.graph.plotAreaFrame.paddingRight = 70.0;
    
    self.graph.title = @"图表";
    CPTTextStyle *textStyle = [CPTTextStyle textStyle];
   // textStyle.color = [CPTColor grayColor];
    self.graph.titleTextStyle = textStyle;
    self.graph.titleDisplacement = CGPointMake(0, -20);
    self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
    //绘图空间
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:16.0f]];
    
    //坐标系
    CPTXYAxisSet *xySet = (CPTXYAxisSet *)self.graph.axisSet;
    //X轴为坐标系的x轴
    CPTXYAxis *x = xySet.xAxis;
    
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc]init];
    lineStyle.lineColor = [CPTColor greenColor];
    lineStyle.lineWidth = 0.5f;
   
    x.axisLineStyle = lineStyle;
    x.majorGridLineStyle = lineStyle;
    x.majorTickLength = 10;
    x.minorGridLineStyle = lineStyle;
    x.minorTickLength = 5;
    x.majorIntervalLength = [NSNumber numberWithFloat:5];
    x.orthogonalPosition = [NSNumber numberWithFloat:0];
    x.title = @"X轴";
    x.titleLocation = [NSNumber numberWithFloat:7.5];
    x.titleOffset = 50;
    CPTXYAxis *y = xySet.yAxis;
    y.axisLineStyle = lineStyle;
    y.title = @"Y轴";
    y.majorGridLineStyle = lineStyle;
    //y.majorTickLength = 10;
    y.minorGridLineStyle = nil;
   // y.minorTickLength = 5;
    y.titleOffset = 30.0f;
    y.majorIntervalLength = [NSNumber numberWithFloat:50];
    y.orthogonalPosition = [NSNumber numberWithFloat:0];

    y.titleLocation = [NSNumber numberWithFloat:150];
    
    //第一个柱状图
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue = [NSNumber numberWithFloat:1];
    barPlot.dataSource = self;
    
    barPlot.identifier = @"Bar Plot";
    [self.graph addPlot:barPlot toPlotSpace:plotSpace];
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{

    return 16;
}


-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{

    NSDecimalNumber *num = nil;
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation:
                num = (NSDecimalNumber *)[NSNumber numberWithUnsignedInteger:idx];
                break;
               case CPTBarPlotFieldBarTip:
                num = (NSDecimalNumber *)[NSNumber numberWithUnsignedInteger:(idx+1)*(idx +1)];
        }
    }
    return num;

}


*/

@end



