//
//  CCTabView.m
//  testView
//
//  Created by yunzhi on 16/11/29.
//  Copyright © 2016年 kx.cai. All rights reserved.
//

#import "CCPageView.h"

#define TabbarHeight 45
#define TabbarWidth 80


@interface CCPageView ()<UIScrollViewDelegate,CCPageBarDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *controllerArray;

@end

@implementation CCPageView{
    
    NSInteger lastIndex;
    
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self initLayoutFrame:frame];
        [self init_data];
    }
    return self;
}

- (void)initLayoutFrame:(CGRect)frame{
    
    [self addSubview:self.scrollView];
   
    CGFloat scrollH=frame.size.height-TabbarHeight;
    self.scrollView.frame=CGRectMake(0, TabbarHeight, frame.size.width, scrollH);
}

#pragma mark private method
- (void)init_data{
    lastIndex=0;
    
}

- (void)init_ui{

    NSInteger count=[self.datasource numberInPageView:self];
    CGFloat contentWidth=self.frame.size.width*count;
    self.scrollView.contentSize=CGSizeMake(contentWidth, 0);
    
    for (int i=0; i<count; i++) {
        UIViewController *controller=[self.datasource pageview:self controllerForIndex:i];
        [[self viewController]addChildViewController:controller];
        CGFloat viewX=i*self.frame.size.width;
        UIView *view=controller.view;
        view.frame=CGRectMake(viewX, 0, self.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:view];
        [self.controllerArray addObject:controller];
        NSString *title=[self.datasource pageview:self titleForIndex:i];
        [self.titleArray addObject:title];
    }
    
    self.pagebar=[[CCPagebar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, TabbarHeight) items:self.titleArray];
    self.pagebar.delegate=self;
    [self addSubview:self.pagebar];
    
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scale=scrollView.contentOffset.x/scrollView.contentSize.width;
    [self.pagebar setVernieScale:scale];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex=(scrollView.contentOffset.x)/scrollView.frame.size.width+0.5;
    if (currentIndex!=lastIndex) {
         [self.pagebar setSelectItemWithIndex:currentIndex];
         lastIndex=currentIndex;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(pageview:didMoveToIndex:)]) {
            [self.delegate pageview:self didMoveToIndex:currentIndex];
        }
    }
}

- (void)pagebar:(CCPagebar *)pagebar didSelectToIndex:(NSInteger)index{
    
    [self.scrollView setContentOffset:CGPointMake(pagebar.frame.size.width*index, 0) animated:YES];
    
}


#pragma mark getter and setter

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.scrollEnabled=YES;
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
    }
    return _scrollView;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray=[NSMutableArray array];
    }
    return _controllerArray;
}

- (void)setDatasource:(id<CCPageViewDataSource>)datasource{
    _datasource=datasource;
    [self init_ui];
}

@end

@interface CCPagebar ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *vernierImage;

@end
@implementation CCPagebar{
    
    NSArray *_titleArray;
    NSInteger currentIndex;
    NSInteger lastIndex;
    
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    
    if (self=[super initWithFrame:frame]) {
        _titleArray=items;
        [self init_data];
        [self initLayoutFrame:frame];
        [self setSelectItemWithIndex:0];
    }
    return self;
}

- (void)initLayoutFrame:(CGRect)frame{
    self.backgroundColor=[UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    self.scrollView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGFloat contentWidth=TabbarWidth*_titleArray.count;
    self.scrollView.contentSize=CGSizeMake(contentWidth, 0);
    
    [self.scrollView addSubview:self.vernierImage];
    
    [self setVernieIndex:0];

    for (int i=0; i<_titleArray.count; i++) {
        NSString *title=_titleArray[i];
        CGFloat titleX=i*TabbarWidth;
        UIButton *titleBtn=[[UIButton alloc]initWithFrame:CGRectMake(titleX, 0, TabbarWidth, TabbarHeight-5)];
        titleBtn.tag=i;
        [titleBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        [self.scrollView addSubview:titleBtn];
    }
}

#pragma mark private method

- (void)init_data{
    _titleSelectColor=[UIColor blueColor];
    _titleNormalColor=[UIColor blackColor];
    _titleSelectFont=[UIFont systemFontOfSize:16];
    _titleNormalFont=[UIFont systemFontOfSize:14];
    lastIndex=NSNotFound;
    
}
- (void)setVernieIndex:(NSInteger)index{
    CGFloat currentX=index*TabbarWidth+(TabbarWidth/2);
    CGFloat currentY=TabbarHeight-5;
    self.vernierImage.center=CGPointMake(currentX, currentY);
    
}

- (void)setVernieScale:(CGFloat)scale{
    if (scale<=-1||scale>=1) {
        return;
    }
    CGFloat scaleW=scale*self.scrollView.contentSize.width+TabbarWidth/2.0;
    CGFloat currentY=TabbarHeight-5;
    self.vernierImage.center=CGPointMake(scaleW, currentY);
    
}

- (void)reloadView{
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *tempBtn=(UIButton *)view;
            [tempBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
            [tempBtn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        }
    }
}
- (void)scrollItemWithIndex:(NSInteger)index{
    
    NSInteger count=self.scrollView.frame.size.width/TabbarWidth;
    CGFloat moveNum=(index-count)*TabbarWidth+(count/2*TabbarWidth);
    
    CGFloat contentWidth=fabs(self.scrollView.contentSize.width-self.scrollView.frame.size.width);
    
    if (moveNum>=(count/2*TabbarWidth)&&moveNum<=contentWidth) {
    }
    else if(moveNum>=contentWidth){
        moveNum=contentWidth;
    }
    else {
        moveNum=0;
    }
    [self.scrollView setContentOffset:CGPointMake(moveNum, 0) animated:YES];
}

- (void)setSelectItemWithIndex:(NSInteger)index{
    currentIndex=index;
    if (currentIndex!=lastIndex) {
        for (UIView *view in self.scrollView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *tempBtn=(UIButton *)view;
                if (tempBtn.tag==index) {
                    tempBtn.selected=YES;
                    tempBtn.titleLabel.font=self.titleSelectFont;
                    lastIndex=currentIndex;
                    [self scrollItemWithIndex:index];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(pagebar:didSelectToIndex:)]) {
                        [self.delegate pagebar:self didSelectToIndex:currentIndex];
                    }
                }
                else{
                    tempBtn.selected=NO;
                    tempBtn.titleLabel.font=self.titleNormalFont;
                }
            }
        }
    }
}

#pragma mark event method

- (void)titleBtnClick:(UIButton *)btn{
    
    [self setSelectItemWithIndex:btn.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setVernieIndex:btn.tag];
    }];
}



#pragma mark getter and setter method

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.delegate=self;
        _scrollView.scrollEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
    }
    return _scrollView;
}
- (UIImageView *)vernierImage{
    if (!_vernierImage) {
        _vernierImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
        _vernierImage.image=[UIImage imageNamed:@"vernier"];
    }
    return _vernierImage;
}

- (void)setTitleNormalFont:(UIFont *)titleNormalFont{
    _titleNormalFont=titleNormalFont;
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont{
    _titleSelectFont=titleSelectFont;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor=titleNormalColor;
    [self reloadView];
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor=titleSelectColor;
    [self reloadView];
}

@end

