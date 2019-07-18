//
//  ViewController.m
//  AutoDemo
//
//  Created by ghyud on 2019/6/21.
//  Copyright © 2019 ghyud. All rights reserved.
//

#import "ViewController.h"
#import "AutoConfig.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *envLabel;
    @end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch ([AutoConfig currentEnv]) {
        case AutoEnvironmentTypeDevelop:
        self.envLabel.text = @"当前测试环境";
        break;
        
        case AutoEnvironmentTypeStaging:
        self.envLabel.text = @"当前预发布环境";
        break;
        
        case AutoEnvironmentTypeProduction:
        self.envLabel.text = @"当前生产环境";
        break;
        
        default:
        break;
    }
}


@end
