//
//  myTimePickerView.h
//  面试项目
//
//  Created by FanGuang on 2018/5/31.
//  Copyright © 2018年 FanGuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myDatePickerDelegate<NSObject>
-(void)getDateFromTP;
@end
@interface myTimePickerView : UIViewController
@property (nonatomic,weak) id<myDatePickerDelegate>delegate;
@property (nonatomic,assign) BOOL isBegin;
-(NSDate *)getDate;
@end
