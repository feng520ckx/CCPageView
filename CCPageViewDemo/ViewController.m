//
//  ViewController.m
//  CCPageViewDemo
//
//  Created by yunzhi on 16/11/30.
//  Copyright © 2016年 daydup. All rights reserved.
//

#import "ViewController.h"
#import "CCPageView.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"

@interface ViewController ()<CCPageViewDataSource,CCPageViewDelegate>

@property (nonatomic, strong) CCPageView *pageView;

@property (nonatomic, strong) NSArray *controllerArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.pageView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberInPageView:(CCPageView *)pageView{
    
    return 3;
}

- (NSString *)pageview:(CCPageView *)pageview titleForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"测试%ld",index];
}

- (UIViewController *)pageview:(CCPageView *)pageview controllerForIndex:(NSInteger)index{
    return self.controllerArray[index];
}

- (void)pageview:(CCPageView *)pageview didMoveToIndex:(NSInteger)index{
    
    NSLog(@"move to index=%ld",index);
    
}

- (NSArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray=@[[Test1ViewController new],[Test2ViewController new],[Test3ViewController new]];
    }
    return _controllerArray;
}
- (CCPageView *)pageView{
    if (!_pageView) {
        _pageView=[[CCPageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
        _pageView.delegate=self;
        _pageView.datasource=self;
    }
    return _pageView;
}


@end
