//
//  NBSingleton.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#ifndef NBSingleton_h
#define NBSingleton_h
/**
 *  设置单例快捷实现
 *
 *  @param name 只需要传入name , 即可生成 shared+name 的单例方法名<br/>
 *  在.h文件中使用  NBSingletonH(name)<br/>
 *  在.m文件中使用  NBSingletonM(name)
 */
// .h 文件中使用
#define NBSingletonH(name) + (instancetype)shared##name;
// .m 文件中使用
#define NBSingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#endif 
/* NBSingleton_h */
