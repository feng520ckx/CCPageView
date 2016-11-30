//
//  CCTabView.h
//  testView
//
//  Created by yunzhi on 16/11/29.
//  Copyright © 2016年 kx.cai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CCPageView;
@class CCPagebar;

@protocol CCPageViewDelegate <NSObject>

- (void)pageview:(nullable CCPageView *)pageview didMoveToIndex:(NSInteger)index;


@end

@protocol CCPageViewDataSource <NSObject>

- (NSInteger)numberInPageView:(nullable CCPageView *)pageView;
- (nullable UIViewController *)pageview:(nullable CCPageView *)pageview controllerForIndex:(NSInteger)index;
- (nullable NSString *)pageview:(nullable CCPageView *)pageview titleForIndex:(NSInteger)index;

@end

@interface CCPageView : UIView

@property (nonatomic, weak, nullable) id<CCPageViewDataSource> datasource;

@property (nonatomic, weak, nullable) id<CCPageViewDelegate> delegate;

@property (nonatomic, retain, nullable) CCPagebar *pagebar;

- (instancetype)initWithFrame:(CGRect)frame;

@end


@protocol CCPageBarDelegate <NSObject>

- (void)pagebar:(nullable CCPagebar *)pagebar didSelectToIndex:(NSInteger)index;

@end


@interface CCPagebar : UIView

@property (nonatomic, retain, nullable) UIColor *titleNormalColor;

@property (nonatomic, retain, nullable) UIColor *titleSelectColor;

@property (nonatomic, retain, nullable) UIFont *titleNormalFont;

@property (nonatomic, retain, nullable) UIFont *titleSelectFont;


@property (nonatomic, weak, nullable) id<CCPageBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

- (void)setSelectItemWithIndex:(NSInteger)index;
- (void)setVernieScale:(CGFloat)scale;

@end
