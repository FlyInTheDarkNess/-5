//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088801710096772"
//收款支付宝账号
#define SellerID  @"736678455@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
//#define MD5_KEY @"460d2ecejo106zbesi9mzy4h39h2mjgz"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAN/SXtaN5qlr9ySWJ5uOrdcR+4eH3eLeC1O0NB6qNRNHlZUf0hM7Lm0lGcyIoj8DdoCejlCxcnm8UhlkK/L8SSs0RYkxor6ifZzJuCt0GEHSPI4NKltAStI1urBFDnK4dByax2WH9b+2+3ixQ3bMtiJECd8PrHUr8ySLv4EOFgeDAgMBAAECgYAcFUo/A3kAowJUfd6kXwei56e2vq5xi8jCDOdJPbQBIkc7ec2jChbuLOyKxE4POAEDbGGQ8GLbsWxfsTjueQc4/3YnAScpbWOxVnFowRXfS/D9owY4rGbEW0CFJ9AGLZA3ff4oces2FEiez4rboMeJuYnWKP3AHkh9NivZBRNMYQJBAPRHqYOrZ5UTKLPAQ1EXgsuO7JX8Ku6ZLJUu6qteaaf75XLs/qcxMuwvw0Dpi/MHoA9kjls2vpzcwnHbzoInmpMCQQDqj27wvVKdThm8aLFMK9o11aYSmMN+IxGvthFdoMfq4Xi+oyDr7H4dDmwOI7X/yEU3Hm3JqeMjoZ9BXPuF2cVRAkBt8TLiB+r+tTjEbeveO26qnxDsECpiaJ4gJpWHu15iNIT4TKHwLbx1gKmoNXS/VNc9Fkzb0K/JebIp/HvdKGXxAkB6pZ1Ay/3Suu/CEIwEZDmpRJmdx7sQzY2F7xGNf3CJZHQaWnnwYqxezRe7HPkhUbq/Y23MsMRP8UawisoJ5yDBAkAjI8NFGE9DDy1mo1t87z/AXro/Rl0LONwtDhnTieQ9b3tWhwpZN4LTdS2WUKNEWU44yuRx0XGH+YcPxcQAI6gT"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
