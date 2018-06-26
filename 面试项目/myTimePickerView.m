//
//  myTimePickerView.m
//  面试项目
//
//  Created by FanGuang on 2018/5/31.
//  Copyright © 2018年 FanGuang. All rights reserved.
//

#import "myTimePickerView.h"

@interface myTimePickerView ()
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL dateChange;
@end

@implementation myTimePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateChange = false;
    //设置最大最小日期（最近300天之内)
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [maxDate dateByAddingTimeInterval:-60*60*24*300];
    self.myDatePicker.maximumDate = maxDate;
    self.myDatePicker.minimumDate = minDate;
    
}
-(void)dateChanged:(UIDatePicker*)sender{
    self.dateChange = true;
    self.date = [self.myDatePicker date];
    NSLog(@"%@",self.date);
}

- (IBAction)ensureBtn:(id)sender {
    if (!_dateChange) {
        self.date = [self.myDatePicker date];
    }
    [self.delegate getDateFromTP];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSDate *)getDate{
    return self.date;
}


@end
