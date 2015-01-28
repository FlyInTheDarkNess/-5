//
//  ViewController.m
//  MQPDemo
//
//  Created by ChaoGanYing on 13-5-6.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import "ViewController.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "iuiueWebViewController.h"


@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *hud;
    Product *MyProduct;
    NSDictionary *MyDic;
    UITableView *MytableView;
    BOOL IsSuccess;//是否支付
}
@end


@implementation ViewController
@synthesize result = _result;
@synthesize Type,RoomId,UsedAccout,RoomName;

-(void)dealloc
{
#if ! __has_feature(objc_arc)
    [_products release];
    [super dealloc];
#endif
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"选择支付方式";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化数据
    IsSuccess = NO;
    MyProduct = [[Product alloc]init];
    MyDic = [NSDictionary dictionary];
    self.view.backgroundColor = [UIColor whiteColor];
    _result = @selector(paymentResult:);
    [self generateData];
    MytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT) style:UITableViewStyleGrouped];
    MytableView.delegate = self;
    MytableView.dataSource = self;
    [self.view addSubview:MytableView];
    
	// Do any additional setup after loading the view, typically from a nib.
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		switch (result.statusCode) {
            case 9000:
            {
                /*
                 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
                 */
                
                //交易成功
                NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
                id<DataVerifier> verifier;
                verifier = CreateRSADataVerifier(key);
                
                if ([verifier verifyString:result.resultString withSign:result.signString])
                {
                    //验证签名成功，交易结果无篡改
                    [[UIApplication sharedApplication].keyWindow makeToast:@"订单支付成功"];
                }

            }
                break;
            case 8000:{
                [[UIApplication sharedApplication].keyWindow makeToast:@"正在处理中"];
            }
                break;
            case 4000:{
                [[UIApplication sharedApplication].keyWindow makeToast:@"订单支付失败"];
            }
                break;
            case 6001:{
                [[UIApplication sharedApplication].keyWindow makeToast:@"用户中途取消"];
                NSLog(@"用户中途取消");
            }
                break;
            case 6002:{
                [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接出错"];
            }
                break;

            default:
                break;
        }
		
    }
    else
    {
        //失败
        [[UIApplication sharedApplication].keyWindow makeToast:@"订单支付失败"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *产生商品列表数据
 */
- (void)generateData{
	NSArray *subjects = [[NSArray alloc] initWithObjects:@"话费充值",
						 @"魅力香水",@"珍珠项链",@"三星 原装移动硬盘",
						 @"发箍发带",@"台版N97I",@"苹果手机",
						 @"蝴蝶结",@"韩版雪纺",@"五皇纸箱",nil];
	NSArray *body = [[NSArray alloc] initWithObjects:@"[四钻信誉]北京移动30元 电脑全自动充值 1到10分钟内到账",
					 @"新年特惠 adidas 阿迪达斯走珠 香体止汗走珠 多种香型可选",
					 @"[2元包邮]韩版 韩国 流行饰品太阳花小巧雏菊 珍珠项链2M15",
					 @"三星 原装移动硬盘 S2 320G 带加密 三星S2 韩国原装 全国联保",
					 @"[肉来来]超热卖 百变小领巾 兔耳朵布艺发箍发带",
					 @"台版N97I 有迷你版 双卡双待手机 挂QQ JAVA 炒股 来电归属地 同款比价",
					 @"山寨国产红苹果手机 Hiphone I9 JAVA QQ后台 飞信 炒股 UC",
					 @"[饰品实物拍摄]满30包邮 三层绸缎粉色 蝴蝶结公主发箍多色入",
					 @"饰品批发价 韩版雪纺纱圆点布花朵 山茶玫瑰花 发圈胸针两用 6002",
					 @"加固纸箱 会员包快递拍好去运费冲纸箱首个五皇",nil];
	
	_products = [[NSMutableArray alloc] init];
    	
	for (int i = 0; i < [subjects count]; ++i) {
		Product *product = [[Product alloc] init];
		product.subject = [subjects objectAtIndex:i];
		product.body = [body objectAtIndex:i];
		if (1==i) {
			product.price = 1;
		}
		else if(2==i)
		{
			product.price = 10;
		}
		else if(3==i)
		{
			product.price = 100;
		}
		else if(4==i)
		{
			product.price = 1000;
		}
		else if(5==i)
		{
			product.price = 2000;
		}
		else if(6==i)
		{
			product.price = 6000;
		}
		else {
			product.price = 0.01;
		}
		
		[_products addObject:product];
#if ! __has_feature(objc_arc)
		[product release];
#endif
	}
	
#if ! __has_feature(objc_arc)
	[subjects release], subjects = nil;
	[body release], body = nil;
#endif
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 60.0f;
    }
	return 44.0f;
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        switch (indexPath.section) {
            case 0:
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
                break;
            case 1:
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
            default:
                break;
        }
            }
    switch (indexPath.section) {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"支付总额：";
                    NSString *all = [NSString stringWithFormat:@"%.1f元",[MyDic[@"amount"] floatValue]+ [MyDic[@"accounts"] floatValue]];
                    cell.detailTextLabel.text = all;
                }
                    break;
                case 1:{
                    cell.textLabel.text = @"扣除租币：";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f元",[MyDic[@"accounts"] floatValue]];
                }
                    break;
                case 2:{
                    cell.textLabel.text = @"应付金额：";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f元",[MyDic[@"amount"] floatValue]];
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:{
                    cell.imageView.image = [UIImage imageNamed:@"image_zfb_icon"];
                    cell.textLabel.text = @"支付宝快捷支付";
                    cell.detailTextLabel.text = @"需安装支付宝客户端";
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                    break;
                case 1:{
                    cell.imageView.image = [UIImage imageNamed:@"image_web_icon"];
                    cell.textLabel.text = @"支付宝网页支付";
                    cell.detailTextLabel.text = @"支持支付宝，信用卡，储蓄卡";
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                    break;
                case 2:{
                    cell.imageView.image = [UIImage imageNamed:@"image_cft_icon"];
                    cell.textLabel.text = @"财付通网页支付";
//                    cell.detailTextLabel.text = ;
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
//#if ! __has_feature(objc_arc)
//	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//													reuseIdentifier:@"Cell"] autorelease];
//#else
//	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//													reuseIdentifier:@"Cell"];
//#endif
//	Product *product = [_products objectAtIndex:indexPath.row];
//	UIView *adaptV = [[UIView alloc] initWithFrame:CGRectMake(10, 0,
//															  cell.bounds.size.width-10, cell.bounds.size.height)];
//	
//	UILabel *subjectLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, adaptV.bounds.size.width, 20)];
//	subjectLb.text = product.subject;
//	[subjectLb setFont:[UIFont boldSystemFontOfSize:14]];
//	subjectLb.backgroundColor = [UIColor clearColor];
//	[adaptV addSubview:subjectLb];
//#if ! __has_feature(objc_arc)
//	[subjectLb release];
//#endif
//	UILabel *bodyLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 25,
//																adaptV.bounds.size.width, 20)];
//	bodyLb.text = product.body;
//	[bodyLb setFont:[UIFont systemFontOfSize:12]];
//	[adaptV addSubview:bodyLb];
//#if ! __has_feature(objc_arc)
//	[bodyLb release];
//#endif
//	UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 20)];
//	priceLb.text = [NSString stringWithFormat:@"一口价：%.2f",product.price];
//	[priceLb setFont:[UIFont systemFontOfSize:12]];
//	[adaptV addSubview:priceLb];
//#if ! __has_feature(objc_arc)
//	[priceLb release];
//#endif
//	[cell.contentView addSubview:adaptV];
//#if ! __has_feature(objc_arc)
//	[adaptV release];
//#endif
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
    
//    NSString *appScheme = @"aiyouyi";
//    NSString* orderInfo = [self getOrderInfo:indexPath.row];
//    NSString* signedStr = [self doRsa:orderInfo];
//    
//    NSLog(@"%@",signedStr);
//    
//    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                             orderInfo, signedStr, @"RSA"];
//	
//    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    [self getOrderArray:YES];
                    break;
                case 1:
                    [self getOrderArrayOnWeb:1];
                    break;
                case 2:
                    [self getOrderArrayOnWeb:2];
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
//    /*
//	 *生成订单信息及签名
//	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
//	 */
//    
//    NSString *appScheme = @"AlipaySdkDemo";
//    NSString* orderInfo = [self getOrderInfo:0];
//    NSString* signedStr = [self doRsa:orderInfo];
//    
//    NSLog(@"%@",signedStr);
//    
//    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                             orderInfo, signedStr, @"RSA"];
//	
//    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
    [self getOrderArray:YES];
}


//OrderInfo签名
-(NSString*)getOrderInfo:(NSInteger)index
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product = [_products objectAtIndex:index];    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;

    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http%3A%2F%2Fwwww.xxx.com"; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

//signedStr签名串
-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

//-(NSString *)pinjie:(NSString *)str{
//    NSString *string = [NSString stringWithFormat:@"%@,%@,%@",@"\"",str,@"\""];
//    return string;
//}

//快捷支付
//获取数据
-(void)getOrderArray:(BOOL) UpDown{
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_DAIQIAN_STRING]];
    
    request.requestMethod = @"POST";
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = @"2088801158078989";
    order.seller = @"736678455@qq.com";
    
    order.tradeNO = [NSString stringWithFormat:@"%@",MyDic[@"ordernum"]]; //订单ID（由商家自行制定）
	order.productName = RoomName; //商品标题
	order.productDescription =[NSString stringWithFormat:@"%@",MyDic[@"subject"]]; //商品描述
	order.amount = [NSString stringWithFormat:@"%@",MyDic[@"amount"]]; //商品价格
	NSString *urlstr =  @"http://user2.muniao.com/pay/alipay_rsa/notify_url.php"; //回调URL
    NSString *return_url = @"http://m.iuiue.com";
    NSString *return_url1 =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)return_url, NULL, (CFStringRef)@"=`~!@#$^*(){}:\"<>?[];',/\\|&", kCFStringEncodingUTF8));
    order.notifyURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlstr, NULL, (CFStringRef)@"=`~!@#$^*(){}:\"<>?[];',/\\|&", kCFStringEncodingUTF8));
    //手拼字符串
    NSString *orderInfo = [NSString stringWithFormat:@"partner=\"%@\"&out_trade_no=\"%@\"&subject=\"%@\"&body=\"%@\"&total_fee=\"%@\"&notify_url=\"%@\"&service=\"mobile.securitypay.pay\"&_input_charset=\"UTF-8\"&return_url=\"%@\"&payment_type=\"1\"&seller_id=\"%@\"&it_b_pay=\"30m\"",order.partner,order.tradeNO,order.productName,order.productDescription,order.amount,order.notifyURL,return_url1,order.seller];

    
    [request addPostValue:order.tradeNO forKey:@"out_trade_no"];
    [request addPostValue:order.productName forKey:@"subject"];
    [request addPostValue:order.productDescription forKey:@"body"];
    [request addPostValue:order.amount forKey:@"total_fee"];
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 0:{
                   [hud hide:YES];
                    /*
                     *生成订单信息及签名
                     *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
                     */
                    
                    NSString *appScheme = @"com.iuiue.muniao";//生成appScheme
                    NSString *signedStr = [NSString stringWithFormat:@"%@",resultDict[@"sign"]];
//                   NSString * signStr = [signedStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *signStr = (NSString *)
                    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                            (CFStringRef)signedStr,
                                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                            NULL,
                                                            kCFStringEncodingUTF8));
                    
//                    utf-8 URLencode
                    
                
                    NSLog(@"%@",signStr);
                     NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)signStr, NULL, (CFStringRef)@"+=`~!@#$^*(){}:\"<>?[];',/\\|&", kCFStringEncodingUTF8));
                    
                    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                             orderInfo, outputStr,@"RSA"];
                    NSLog(@"%@",orderString);
                    
                    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        hud.labelText = @"加载失败。。";
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    //异步加载
    [request startAsynchronous];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self postToTop];
    if (IsSuccess) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请根据您真实支付情况，进行下一步" delegate:self cancelButtonTitle:@"支付失败,继续支付" otherButtonTitles:@"支付成功", nil];
        [alert show];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IsSuccess = YES;
}



//支付宝网页支付/财付通网页支付
-(void)getOrderArrayOnWeb:(NSInteger)type{
    
    __weak ASIFormDataRequest *request;
    if (type == 1) {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_PAY_ZFB_WEB]];
    }else if(type == 2){
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_PAY_CFT_WEB]];
    }
    
    
    request.requestMethod = @"POST";
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    
    
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    NSString *orderid = [NSString stringWithFormat:@"%@",MyDic[@"orderid"]];
    [request addPostValue:orderid forKey:@"id"];
//    NSString *typeStr = [NSString stringWithFormat:@"%d",type];
//    [request addPostValue:typeStr forKey:@"i_type"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    NSString *url = [NSString stringWithFormat:@"%@",resultDict[@"url"]];
                    iuiueWebViewController *WebVc = [[iuiueWebViewController alloc]init];
                    if (type==1) {
                        WebVc.title = @"支付宝网页支付";
                    }else if(type == 2){
                        WebVc.title = @"财付通网页支付";
                    }
                    WebVc.URL = url;
                    [self.navigationController pushViewController:WebVc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        hud.labelText = @"加载失败。。";
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //异步加载
    [request startAsynchronous];
    
}
//获取数据
-(void)postToTop{
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_POST_TOTOP]];
    
    request.requestMethod = @"POST";
    
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:Type forKey:@"type"];
    [request addPostValue:UsedAccout forKey:@"check_accounts"];
    [request addPostValue:RoomId forKey:@"id"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    MyDic = resultDict;
                    [MytableView reloadData];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        hud.labelText = @"加载失败。。";
        
    }];
    
    //异步加载
    [request startAsynchronous];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3]  animated:YES];
            break;
            
        default:
            break;
    }
}



@end
