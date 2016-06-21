//
//  ZBJCalendarWeekView.m
//  ZBJCalendar
//
//  Created by gumpwang on 16/2/25.
//  Copyright © 2016年 ZBJ. All rights reserved.
//

#import "ZBJCalendarWeekView.h"
#import "NSDate+ZBJAddition.h"

@interface ZBJCalendarWeekView ()
@property (nonatomic, strong) NSMutableArray *adjustedSymbols;
@end

@implementation ZBJCalendarWeekView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSCalendar *calendar = [NSDate gregorianCalendar];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.calendar = calendar;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = calendar;
        
        if (self.adjustedSymbols == nil) {
            self.adjustedSymbols = [[NSMutableArray alloc] init];
        }
        for (int day = 1; day <= 7; day++) {
            components.day = day;
            dateFormatter.dateFormat = @"E";
            [self.adjustedSymbols addObject:[dateFormatter stringFromDate:components.date]];
        }
        
        
        for (int i = 0 ; i < self.adjustedSymbols.count; i++) {
            CGFloat w = CGRectGetWidth(self.frame)/7;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(w * i, 0, w, CGRectGetHeight(self.frame))];
            label.tag = 10901 + i;
            label.textColor = [UIColor darkTextColor];
            label.font = [UIFont systemFontOfSize:15];
            label.text = [self.adjustedSymbols[i] uppercaseString];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
        }
        
        // bottom line is default style, you
        if (!self.bottomLine) {
            self.bottomLine = [CALayer layer];
            self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
            self.bottomLine.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
            [self.layer addSublayer:self.bottomLine];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < 7; i++) {
        UILabel *label = [self viewWithTag:10901 + i];
        CGFloat width = (self.frame.size.width - _contentInsets.left - _contentInsets.right) / 7;
        label.frame = CGRectMake(_contentInsets.left + i * width, 0, width, CGRectGetHeight(self.frame));
    }
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
}

- (void)setDelegate:(id<ZBJCalendarWeekViewDelegate>)delegate {
    _delegate = delegate;
    for (int i = 0; i < self.adjustedSymbols.count; i++) {
        UILabel *label = [self viewWithTag:10901 + i];
        if (label && _delegate && [_delegate respondsToSelector:@selector(calendarWeekView:configureWeekDayLabel:atWeekDay:)]) {
            [_delegate calendarWeekView:self configureWeekDayLabel:label atWeekDay:i];
        }
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self layoutSubviews];
}

@end
