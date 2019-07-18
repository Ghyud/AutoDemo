//
//  AutoConfig.m
//  AutoDemo
//
//  Created by ghyud on 2019/6/21.
//  Copyright © 2019 ghyud. All rights reserved.
//

#import "AutoConfig.h"

const static NSString *kDevelopRegx = @"^(develop|feature)_.*$";
const static NSString *kStagingRegx = @"^master";
const static NSString *kProductionRegx = @"^production";

@interface AutoConfig()

@property (nonatomic, copy) NSString *baseURL;

@property (nonatomic, assign) AutoEnvironmentType env;

@property (nonatomic, strong) NSPredicate *developPredicate;
@property (nonatomic, strong) NSPredicate *stagingPredicate;
@property (nonatomic, strong) NSPredicate *productionPredicate;

@end

@implementation AutoConfig

#pragma mark -Public Methods

+ (NSString *)baseURL {
    return [AutoConfig shared].baseURL;
}

+ (AutoEnvironmentType)currentEnv {
    return [AutoConfig shared].env;
}

+ (void)setEnviroment:(AutoEnvironmentType)env {
    [AutoConfig shared].env = env;
    [[AutoConfig shared] updateConfig];
}

#pragma mark -life cycle

+ (AutoConfig *)shared {
    
    static AutoConfig *_config = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[AutoConfig alloc] init];
        [_config commonInit];
    });
    return _config;
}

- (void)commonInit {
    _developPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kDevelopRegx];
    _stagingPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kStagingRegx];
    _productionPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kProductionRegx];
    _env = AutoEnvironmentTypeDevelop;
    
    [self envForCurrentBranch];
    [self updateConfig];
}

/**
 根据分支名称，进行正则匹配，指定环境
 */
- (void)envForCurrentBranch {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * branch = infoDict[@"GitCommitBranch"];
    
    if ([self.developPredicate evaluateWithObject:branch]) {
        //测试
        self.env = AutoEnvironmentTypeDevelop;
    }
    else if ([self.stagingPredicate evaluateWithObject:branch]) {
        //预发布
        self.env = AutoEnvironmentTypeStaging;
    }
    else if ([self.productionPredicate evaluateWithObject:branch]) {
        //生产环境
        self.env = AutoEnvironmentTypeProduction;
    }
}


- (void)updateConfig {
    /**
     * 对根据环境变化的参数进行配置
     */
    switch (self.env) {
        case AutoEnvironmentTypeDevelop:
            self.baseURL = @"http://test.com.cn";
            break;
            
        case AutoEnvironmentTypeStaging:
            self.baseURL = @"https://staging.com.cn";
            break;
            
        case AutoEnvironmentTypeProduction:
            self.baseURL = @"https://production.com.cn";
            break;
            
        default:
            self.baseURL = @"http://test.com.cn";
            break;
    }
}

@end
