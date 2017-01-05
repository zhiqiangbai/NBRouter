# NBRouter 
###这是一个通过字符串进行控制器之间的跳转,彻底解脱只有在控制器中才能跳转,有了这个,你可以在任何地方进行控制器的跳转
    支持从纯代码,xib,storyboard中创建的控制器,1.2.0开始支持链式语法调用
###结构
  >NBRouter 项目m文件夹
  * NBSingleton 一个单例宏
  * NBURLRouter 公开的接口类,主要就使用这个类进行开发
  * NBURLNavigation 内部导航管理类,进行跳转等实际操作
  * UIViewController+NBURLRouter 参数信息,以及控制器的提取等
  * NBRouter 使用时导入这个头文件即可
  * NBURLRouteMaker 使用这个配置相关的设置属性,比如url,动画,回调等参数
  

##尚待改善(不影响使用,只是对完善的探索)
  * ~~从storyboard中加载需要在字符串中指定 `storyboardName.storyboardId`,这样感觉不是很好(感觉问题)~~
  * 1.2.0版本新增 IntentToMaker & IntentTo 方法,以及NBURLRouteMaker类来配置相关设置,解决了这个问题,如果还使用其他的push/present方法,当然还      需要这样设置
  * 还无法区分http:// & https:// 是加载网页还是加载本地控制器 (目前把所有http & https 链接当网页处理)
  * 其他
  
##图片介绍
![NBRouter](https://github.com/NapoleonBaiAndroid/NBRouter/blob/master/NBRouter/Res/nbrouter.gif "样例图片")
   
##怎样使用?
1. 设置相关配置
2. 正常化的push,modal操作
3. _新增链式语法操作_

##1.2.0版本新操作
<NBURLRouter类>
新增
``` Objective-c
/**
 传入maker对象,进行跳转到指定控制器,
 使用这个方法,是不需要设置多个加载控制器的协议头,直接在maker中设置即可,
 当前可直接使用:maker.*.*.push()进行跳转切换,后期再改进

 @param maker 配置
 */
+ (void)IntentToMaker:(NBURLRouteMaker *)maker;

/**
 在block中设置maker,
 使用这个方法,是不需要设置多个加载控制器的协议头,直接在maker中设置即可

 @param block 回调,设置maker配置参数
 */
+ (void)IntentTo:(void(^)(NBURLRouteMaker *))block;

```

<NBURLRouteMaker类>,负责对目标控制器的设置等操作,其结合NBURLRouter类使用:

``` Objective-c
//链式语法使用,这里的push()操作是隐式调用了 IntentToMaker函数,当然,如果不是用push(),自己调用也行;
maker.intentUrlStr(@"bzqnormal://nbrouter/pushsecondviewcontroller?userName=张三&pwd=123456").hidesBottomBarWhenPushed(YES).animate(YES).handler(^(NSDictionary *dict) {
                NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                weakSelf.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
}).push();


//采用IntentTo函数
[NBURLRouter IntentTo:^(NBURLRouteMaker * maker) {
                maker.intentUrlStr(@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456").hidesBottomBarWhenPushed(YES).animate(YES).handler(^(NSDictionary *dict) {
                    NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                    self.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
                });
}];


```

##API简介<NBURLRouter类>
  PUSH API
  ``` Objective-c
/**
 *  push控制器
 *
 *  @param viewController 目的控制器
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  push控制器
 *
 *  @param viewController   目的控制器
 *  @param handler          回调函数参数
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated callBackHandler:(CallBackHandler)handler;

/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated;

/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param handler   回调函数参数
 */
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated callBackHandler:(CallBackHandler)handler;


/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated;

/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param handler   回调函数参数
 */
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated callBackHandler:(CallBackHandler)handler;
  ```
  POP API
  ``` Objective-c
/** pop掉一层控制器 */
+ (void)popViewControllerAnimated:(BOOL)animated;
/** pop掉两层控制器 */
+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
/** pop掉times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
/** pop到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;
/** pop到指定控制器 */
+ (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
  ```
  
  MODAL API
  ``` Objective-c
      
/**
 *  modal控制器
 *
 *  @param viewControllerToPresent 目标控制器
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器
 *
 *  @param viewControllerToPresent 目标控制器
 *  @param handler                 回调函数参数
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler;

/**
 *  modal控制器
 *
 *  @param viewControllerToPresent 目标控制器
 *  @param classType               需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器
 *
 *  @param viewControllerToPresent 目标控制器
 *  @param classType               需要添加的导航控制器 eg.[UINavigationController class]
 *  @param handler                 回调函数参数
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler;



/**
 *  modal控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param handler   回调函数参数
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler;

    
/**
 *  modal控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;


/**
 *  modal控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param handler   回调函数参数
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler;


/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param classType 需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;


/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param classType 需要添加的导航控制器 eg.[UINavigationController class]
 *  @param handler   回调函数参数
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler;

    
/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param classType 需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param classType 需要添加的导航控制器 eg.[UINavigationController class]
 *  @param handler   回调函数参数
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler;
  ```
  
  DISMISS API
  ``` Objective-c
    /** dismiss掉1层控制器 */
+ (void)dismissViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;
    /** dismiss掉2层控制器 */
+ (void)dismissTwiceViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;
    /** dismiss掉times层控制器 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)animated completion: (void (^ __nullable)(void))completion;
    /** dismiss到根层控制器 */
+ (void)dismissToRootViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;
    
  ```
 ##实际操作
``` Objective-c
    //在应用被打开的时候就执行这些配置操作
    //这是设置从代码中创建控制器的协议头
    [NBURLRouter setSchemeFromCodeViewController:@"bzqnormal"];
    //这是设置从xib中加载控制器的协议头
    [NBURLRouter setSchemeFromXibLoadViewController:@"bzqxib"];
    //这是设置从storyboard中加载控制器的协议头
    [NBURLRouter setSchemeFromStoryboardLoadViewController:@"bzqsb"];
    //这是设置读取连接与控制器配置的plist文件,可参考项目中的此文件配置
    [NBURLRouter loadConfigDictFromPlist:@"NBRouter.plist"];
    //设置根控制器,这是从storyboard中加载的根控制器,如果不需要自己设置,当然就不设置
    [NBURLRouter setRootURLString:@"bzqsb://nbrouter/Main.HomeTab"];

```
    在设置好后,就可以进行相关的操作了,当需要push的时候,直接用NBRouter push...操作替换
    需要present的时候,用 NBRouter present... 替换即可
    比如,我们的PUSH:
``` Objective-c
     switch (indexPath.row) {

        case 0:
            [NBURLRouter pushURLString:@"bzqnormal://nbrouter/pushsecondviewcontroller?userName=张三&pwd=123456" animated:YES];
            break;
        case 1:
            //隐藏tabbar
            self.hidesBottomBarWhenPushed = YES;
            [NBURLRouter pushURLString:@"bzqnormal://nbrouter/pushsecondviewcontroller" query:@{@"userName":@"张三",
                        @"pwd":@"123456"}
             animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            break;
            
        case 2:
        {
            [NBURLRouter pushURLString:@"bzqnormal://nbrouter/pushsecondviewcontrollerpushsecondviewcontroller?userName=张三&pwd=123456" animated:YES callBackHandler:^(NSDictionary *dict) {
                NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                weakSelf.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
            }];
        }
            break;
        //case 3 是从xib中加载控制器, 是否传递参数以及是否需要返回值,与code方式一样,没啥不同之处
        case 3:
            [NBURLRouter pushURLString:@"bzqxib://nbrouter/xibviewcontroller?userName=xib跳转&pwd=1234565&isPush=YES" animated:YES];
            break;
        case 4:
            //唯一需要注意的是:xxx://xxx/xx   ,最后一个"/" 后面,必须按照规范给出 storyboardName.storyboardId, eg:Main.StoryboardViewController , 其他与上面一致
            [NBURLRouter pushURLString:@"bzqsb://nbrouter/Main.StoryboardViewController?userName=xib跳转&pwd=1234565" animated:YES];
            break;
        case 5:
            //http 也是类似
            self.hidesBottomBarWhenPushed = YES;
            [NBURLRouter pushURLString:@"https://www.baidu.com" animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            break;
    }
    //更多方式请参考上面的介绍...

```
    那MODAL操作也是如此简单了,比如
``` Objective-c
        //MODAL 跳转方式,从code ,从xib , 从 storyboard 中加载都是一样的,区别不同就是要定义好自己的协议即可,按照规范书写就好了
    self.label.text = @"显示返回数据";
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456" animated:YES completion:nil];
            break;
        case 1:
            
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller" query:@{@"userName":@"张三",@"pwd":@"123456"} animated:YES completion:nil];
            break;
            
        case 2:
        {
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456" animated:YES completion:nil callBackHandler:^(NSDictionary *dict) {
                NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                weakSelf.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
            }];
        }
            break;
        case 3:
            //UINavigationController 是系统的导航栏控制器,如果自己定义,也是可以的,只要继承自UINavigationController就可
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456" animated:YES withNavigationClass:[UINavigationController class] completion:nil];
            break;
    }
    //更多方式请参考上面的介绍...
```
    当然,我们的POP和Dismiss操作就更简单了,这里就简单举个例子好了:
``` Objective-c
    //POP
    [NBURLRouter popViewControllerAnimated:YES];

    //Dismiss
    [NBURLRouter dismissViewControllerAnimated:YES completion:^{
    }];

    //更多方式请参考上面的介绍...
```
### 也说了这么多了,肯定有你适合你的菜.当然了,除了这些,还有一个需要介绍一下,因为目前自己就是通过一个简单的block来处理的,就是返回值的问题:
``` Objective-c
  typedef void(^ __nullable CallBackHandler)(id parmas);
  //这里的参数是一个id类型,主要是考虑可能会有多个参数,所以这样设置了,Demo中使用的是NSDictionary,
  //当然,你可以自己定制一个Model来负责数据传递,如果只有一个参数,肯定就没有这么麻烦了,且行且珍惜吧
```
##当然,这个是支持COCOAPODS的
    pod 'NBRouter' #版本号自己控制



 
