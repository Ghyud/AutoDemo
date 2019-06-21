//
//  AutoConfig.h
//  AutoDemo
//
//  Created by ghyud on 2019/6/21.
//  Copyright © 2019 ghyud. All rights reserved.
//
//  接口配置

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AutoEnvironmentType) {
    AutoEnvironmentTypeDevelop = 1, //开发/测试环境
    AutoEnvironmentTypeStaging, //预发布环境
    AutoEnvironmentTypeProduction, //生产环境
};

NS_ASSUME_NONNULL_BEGIN

@interface AutoConfig : NSObject


+ (NSString *)baseURL;

/**
 自定义环境，一步实现应用内环境切换 及 方便开发调试

 @param env 要切换到的环境
 */
+ (void)setEnviroment:(AutoEnvironmentType)env;

@end

NS_ASSUME_NONNULL_END
