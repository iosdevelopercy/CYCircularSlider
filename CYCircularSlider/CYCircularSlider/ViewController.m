//
//  ViewController.m
//  CYCircularSlider
//
//  Created by user on 2018/3/23.
//  Copyright © 2018年 com. All rights reserved.
//

#import "ViewController.h"
#import "CYCircularSlider.h"

@interface ViewController ()<senderValueChangeDelegate>

@property (nonatomic,strong)CYCircularSlider *circularSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect sliderFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width-275)/2, ([UIScreen mainScreen].bounds.size.height-275)/2, 275,275);
    _circularSlider =[[CYCircularSlider alloc]initWithFrame:sliderFrame];
    [self.view addSubview:_circularSlider];
    _circularSlider.delegate = self;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(self.circularSlider.frame.origin.x+50, self.circularSlider.frame.origin.y+self.circularSlider.frame.size.height+50, 50, 50)];
    [button1 setTitle:@"-" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(mov) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(self.circularSlider.frame.origin.x+self.circularSlider.frame.size.width -50, self.circularSlider.frame.origin.y+self.circularSlider.frame.size.height+50, 50, 50)];
    [button2 setTitle:@"+" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
}

-(void)add{
//     [_circularSlider setAngel:40];
    [_circularSlider setAddAngel];
}

-(void)mov{
//     [_circularSlider setAngel:140];
    [_circularSlider setMovAngel];
}

-(void)senderVlueWithNum:(int)num{
//    if (num<0) {
//        if (num == -5) {
//            num = 14;
//        }
//        if (num == -6) {
//            num = 13;
//        }
//        if (num == -7) {
//            num = 12;
//        }
//    }
//    NSLog(@"%d",num);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
