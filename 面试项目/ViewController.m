//
//  ViewController.m
//  面试项目
//
//  Created by FanGuang on 2018/5/31.
//  Copyright © 2018年 FanGuang. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "myTimePickerView.h"
#import "MBProgressHUD.h"
@interface ViewController ()<myDatePickerDelegate>
@property (nonatomic,strong) myTimePickerView *datePicker;
- (IBAction)confirmBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *endTimeView;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeView;
@property (nonatomic,strong) NSDate *beginDate;
@property (nonatomic,strong) NSDate *endDate;
@property(nonatomic,copy)NSArray* info;
@property (nonatomic,strong) MBProgressHUD *hud;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(NSArray *)info
{
    if (!_info) {
        _info = [[NSArray alloc]init];
    }
    return _info;
}
-(myTimePickerView*)datePicker{
    if(!_datePicker){
        _datePicker = [[myTimePickerView alloc]init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}
//设置开始时间按钮
- (IBAction)beginBtn:(id)sender {
    self.datePicker.isBegin = YES;
    [self presentViewController:self.datePicker animated:YES completion:nil];
}
//设置结束时间按钮
- (IBAction)endBtn:(id)sender {
    self.datePicker.isBegin = NO;
    [self presentViewController:self.datePicker animated:YES completion:nil];
}

//代理使用(获取日期)方法
-(void)getDateFromTP{
    if (self.datePicker.isBegin){
        self.beginDate = self.datePicker.getDate;
        self.beginTimeView.text = [self dateToString:self.beginDate];
    }else{
        self.endDate = self.datePicker.getDate;
        self.endTimeView.text = [self dateToString:self.endDate];
    }
    
    [self.datePicker dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)dateToString:(NSDate*)date{
    NSLog(@"%@",date);
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dataString = [pickerFormatter stringFromDate:date];
    return dataString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询按钮
- (IBAction)confirmBtn:(id)sender {
    //如果时间选择错误需要重新选择
    if([self.endDate timeIntervalSinceDate:self.beginDate] <= 0 ){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"时间选择错误，请重新选择" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
    }else{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.label.text = NSLocalizedString(@"查询数据中...", @"你好");
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSURL * url = [NSURL URLWithString:@"https://api.gdax.com/products/BTC-USD/candles?granularity=86400"];
            [self taskWithURL:url];
            
        });
    }
    
    
}

-(void)taskWithURL:(NSURL *)url{
    
    //1.获取数据
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //反序列化
        self.info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",self.info);
        
        //2处理数据
        long time1 = [self.beginDate timeIntervalSince1970];
        long time2 = [self.endDate timeIntervalSince1970];
    
        
        //找出时间范围内的数据
        self.result =  [[NSMutableArray alloc]init];
        for (int i = 0; i < self.info.count; i++)
        {
            NSArray* arr = self.info[i];
            NSNumber* num = arr[0];
            if (num.longValue >time1 && num.longValue <time2) {
                [self.result addObject:arr];
            }
        }
        int i = 10;
        if(self.result.count<10){
            i = (int)self.result.count;
        }
        //按照收盘价排序并取前10(如果不到10个数据，则有多少取多少)
        NSArray *sortArr = [self.result sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2){ return -[obj1[4] compare:obj2[4]]; }];
        sortArr = [sortArr subarrayWithRange:NSMakeRange(0, i)];
        NSLog(@"%@",sortArr);
        
        //3展示数据
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TableViewController* tv = [TableViewController new];
            tv.sortArr = sortArr;
            [self presentViewController:tv animated:YES completion:nil];
            [self.hud hideAnimated:YES];
        });

    }] resume];
 
}

    @end
    
