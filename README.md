# NBRouter 
### 这是一个通过字符串进行控制器之间的跳转,彻底解脱只有在控制器中才能跳转,有了这个,你可以在任何地方进行控制器的跳转
    支持从纯代码,xib,storyboard中创建的控制器,
1. 1.2.0开始支持链式语法调用
2. 1.3.0 简化API,提供简洁的操作方式

### 结构
  >NBRouter 项目m文件夹
  
* NBSingleton 一个单例宏  
* NBURLRouter 公开的接口类,主要就使用这个类进行开发
* NBURLNavigation 内部导航管理类,进行跳转等实际操作
* UIViewController+NBURLRouter 参数信息,以及控制器的提取等
* NBRouter 使用时导入这个头文件即可
* NBURLRouteMaker 使用这个配置相关的设置属性,比如url,动画,回调等参数
* NBURLRouteBacker 使用这个类配置相关的返回操作属性,当然同时分开设置了dismissBacker 以及popBacker
  

## 说明
*    ~~从storyboard中加载需要在字符串中指定 `storyboardName.storyboardId`,这样感觉不是很好(感觉问题)~~
*    ~~1.2.0版本新增 IntentToMaker & IntentTo 方法,以及NBURLRouteMaker类来配置相关设置,解决了这个问题,如果还使用其他的push/present方法,当然还需要这样设置~~
*    1.3.0版本都属稳定版本,对外API不在进行删除,只进行特定增加.
*    还无法区分http:// & https:// 是加载网页还是加载本地控制器 (目前把所有http & https 链接当网页处理)
*    其他
  
## 图片介绍
![NBRouter](https://github.com/NapoleonBaiAndroid/NBRouter/blob/master/NBRouter/Res/nbrouter.gif "样例图片")
   
## 怎样使用?
1. 设置相关配置
2. 正常化的push,modal操作
3. _新增链式语法操作_

## 实战使用
## 一. 配置urls

``` Objective-c
    //配置urls属性
    [NBURLRouter setUrlsConfigDict:[self loadUrls]];
    //dict 配置如下
    格式:
    1. 如果是采用http / https 协议的url,目前必须设置为这样. 
    2. 其中NBWebViewController是指对应要跳转的控制器名称,拼写不能错误
    @"http" : @"NBWebViewController"
    @"https" : @"NBWebViewController"
    2. 如果采用的是自定义协议,比如router://
    @"router" : {
        @"router://home" : @"HomeViewController",
        ...
    }
    3. 如果没有采用协议或者说采用了协议都可以使用:
    @"router://home" : @"HomeViewController",
    @"router://profile" : @"ProfileViewController",
    @"setting" : @"SettingViewController"
 
    当然,非常建议使用协议内子集方式.这里后面出现的控制器名称必须与目标控制器名称一一对应.
 完整版:
    {
        @"http" : @"",
        @"https" : @"",
        @"router" : {
                    @"router://home" : @"HomeViewController",
                    ...
                    }
        @"other" : @"OtherViewController"
    }
具体的可以查看案例中的 AppDelegate+NBRouterUrlsConfig.m

```

## 二. 设置根控制器

``` Objective-c
    //采用 setRootViewControllerForMaker 方式,在maker中指定 intentUrlStr即可
    [NBURLRouter setRootViewControllerForMaker:^(NBURLRouteMaker * maker) {
        maker.intentUrlStr(@"nbrouter://home").storyboardName(@"Main").identifier(@"HomeTab");
    }];

```

## 三. 跳转到控制器, 更多方式可查看案例中 [ModalHomeViewController.m](https://github.com/NapoleonBaiAndroid/NBRouter/blob/master/NBRouter/ModalHomeViewController.m) 和 [PushHomeViewController.m](https://github.com/NapoleonBaiAndroid/NBRouter/blob/master/NBRouter/PushHomeViewController.m)
    
``` Objective-c
    // PUSH跳转
    [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://pushsecond?userName=张三&pwd=123456&index=1")
                .animate(YES);
    }];
    
    // PRESENT跳转
    [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://modalchild?userName=张三&pwd=123456&index=1")
                .navigationClass([UINavigationController class])
                .animate(YES);
    }];
    
    // 跳转的方式分为 push  和 present 操作, 主要通过 NBURLRouteMaker 进行设置,目前并未对code / storyboard / xib 目标控制器分别制作 maker    
    

```


## 四.NBURLRouteMaker说明

``` Objective-c
    // 特别说明的是 parmas 属性,这个是用来传值的,就是说A To B时,可以通过
    // maker.parmas 进行传值,当然,也可以直接maker.intenUrlStr(@"urls?parma1=1&parma2=2"),
    // 如果同时存在,则取parmas中数据.parmas传递的是一个字典类型数据


    //本类采用block方式制定了链式操作,其中也制定了页面跳转所需的配置参数
    @property(nonatomic,copy,readonly)LoadStoryboardName storyboardName;///< storyboard name
    @property(nonatomic,copy,readonly)LoadXibName xibName;///< xib name
    @property(nonatomic,copy,readonly)LoadIdentifier identifier;///< identifier
    @property(nonatomic,copy,readonly)FromBundle bundle;///< bundle , 默认为:[NSBundle mainBundle]
    @property(nonatomic,copy,readonly)HidesBottomBarWhenPushed hidesBottomBarWhenPushed;///< push时是否隐藏底部栏,默认隐藏
    @property(nonatomic,copy,readonly)IntentUrl intentUrlStr;///< 跳转url
    @property(nonatomic,copy,readonly)Animate animate;///< 动画
    @property(nonatomic,copy,readonly)NavigationClass navigationClass;///< 自定义导航栏Class
    @property(nonatomic,copy,readonly)IntentViewController viewController;///< 直接跳转到对应ViewController
    @property(nonatomic,copy,readonly)Parmas parmas;///< 跳转时携带参数
    @property(nonatomic,copy,readonly)Handler handler;///< 回调(页面返回时调用传参数)
    @property(nonatomic,copy,readonly)CompletionHandler completion;///< 模态跳转时回调

```

## 五. 控制器的返回

``` Objective-c
/**
 模态跳转dismiss

 @param backerBlock 回调配置backer参数
 */
+ (void)dismiss:(void(^ _Nullable)(NBURLRouteDismissBacker * backer))backerBlock;

/**
 向上退一层
 */
+ (void)dismiss;

/**
 导航栏跳转pop

 @param backerBlock 回调皮遏制backer参数
 */
+ (void)pop:( void(^ _Nullable)(NBURLRoutePopBacker * backer))backerBlock;

/**
 向上退一层
 */
+ (void)pop;
// 具体使用可以参照如下

[NBURLRouter dismiss:^(NBURLRouteDismissBacker * _Nonnull backer) {
   
   if (self.index % 6 == 0) {
       // 回退到根界面
       backer.toRoot();
   }else{
       // 这里是测试回退到某个界面
       NSUInteger times = arc4random()%self.index;
       backer.times( times == 0 ? 1 : times);
   }
}];

// 或者pop  针对backer.viewController(@"PushSecondViewController");说明一下
// 这是 回退到最近的一个PushSecondViewController 控制器上

[NBURLRouter pop:^(NBURLRoutePopBacker * backer) {
   if (self.index % 4 == 0) {
       // 回退到根界面
       backer.toRoot();
   }else if(self.index %3 == 0){
       backer.viewController(@"PushSecondViewController");
   }else{
       // 这里是测试回退到某个界面
       NSUInteger times = arc4random()%self.index;
       backer.times( times == 0 ? 1 : times);
   }

}];

```

## 六. 控制器返回值

``` Objective-c
  typedef void(^ __nullable CallBackHandler)(id parmas);
  //这里的参数是一个id类型,主要是考虑可能会有多个参数,所以这样设置了,Demo中使用的是NSDictionary,
  //当然,你可以自己定制一个Model来负责数据传递,如果只有一个参数,肯定就没有这么麻烦了,且行且珍惜吧
```



##当然,这个是支持COCOAPODS的
    pod 'NBRouter' #版本号自己控制



 


