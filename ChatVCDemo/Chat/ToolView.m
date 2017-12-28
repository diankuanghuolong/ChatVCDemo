//
//  ToolView.m
//  ChatVCDemo
//
//  Created by Ios_Developer on 2017/12/28.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ToolView.h"
#import "Masonry.h"

//--------------------------- 宏定义参数 、建议项目使用时，放在pch中 ----------------------------------
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/*
 定义安全区域到顶部／底部高度
 */
#define SafeAreaTopHeight (SCREEN_WIDTH == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

//高度系数:(821x 667 8和6)
#define HeightCoefficient (SCREEN_HEIGHT == 812.0 ? 667.0/667.0 : SCREEN_HEIGHT/667.0)

//宽度系数：(821x 667 8和6)
#define WidthCoefficient (SCREEN_WIDTH == 375.0 ? 375.0/375.0 : SCREEN_WIDTH/375.0)
//-----------------------------------------------------------------------------------------------


/*
 定义toolView 中的一些参数
 */
//textview的参数
#define tvWith  SCREEN_WIDTH - (30 + 60 + 10)*WidthCoefficient //-----chatTV宽度
#define tvHeight 40*HeightCoefficient         //----------------------chatTV高度
#define tvFont 14             //--------------------------------------chatTVfont
#define tvColor [UIColor colorWithRed:57/255.0 green:54/255.0 blue:43/255.0 alpha:1]

@interface ToolView()<UITextViewDelegate>

@property (nonatomic ,strong)UIButton * sentBtn;
@end
@implementation ToolView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.chatTV];
        [_chatTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.edges.mas_offset(UIEdgeInsetsMake(7*HeightCoefficient, 10*WidthCoefficient, 7*HeightCoefficient, 75*WidthCoefficient));
        }];
        
        //sentBtn
        CGFloat sentBtnWith = 60*WidthCoefficient, sentBtnHeight = tvHeight*HeightCoefficient;
        UIColor *sentBtnColor = [UIColor colorWithRed:125/255.0 green:207/255.0 blue:247/255.0 alpha:1];
        UIButton * sentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        sentBtn.backgroundColor = sentBtnColor;
        [sentBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sentBtn.layer.cornerRadius = 10;
        sentBtn.layer.masksToBounds = YES;
        [sentBtn addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sentBtn];
        _sentBtn = sentBtn;
        
        __weak typeof(self) weakSelf = self;
        [sentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(weakSelf).offset(- 10*WidthCoefficient);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-5*HeightCoefficient);
            make.width.mas_equalTo(sentBtnWith);
            make.height.mas_equalTo(sentBtnHeight);
        }];
        
    }
    return self;
}

#pragma mark  ===== setter 、getter  =====
-(UITextView*)chatTV
{
    if (!_chatTV)
    {
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectZero];
        tv.delegate = self;
        tv.scrollEnabled = YES;
        tv.layer.cornerRadius = 10;
        tv.layer.masksToBounds = YES;
        tv.keyboardType = UIKeyboardTypeDefault;
        tv.returnKeyType = UIReturnKeyDone;
        tv.backgroundColor = [UIColor whiteColor];
        tv.font = [UIFont systemFontOfSize:tvFont];
        tv.textColor = tvColor;
        [self addSubview:tv];
        _chatTV = tv;
    }
    return _chatTV;
}

#pragma mark ===== actions  =====
-(void)sendMessageAction:(UIButton *)sender
{
    if (_sendMessage)
    {
        _sendMessage(_chatTV);
        //修改frame
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(tvHeight);
        }];
        [_chatTV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tvHeight*HeightCoefficient);
        }];
    }
}

#pragma mark
#pragma  mark --tv delegate method
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"] && textView.returnKeyType != UIReturnKeyDefault)
    {
        NSLog(@"回车");
        //发送消息
        [self sendMessageAction:nil];
        return NO;
    }
    
    if (textView == _chatTV)
    {
//        CGFloat h = ceilf([textView sizeThatFits:textView.frame.size].height)*HeightCoefficient;
        CGFloat h = [self sizeWithText:str fontSize:tvFont].height;
        h = h > 20 * 5*HeightCoefficient ? 20 * 5*HeightCoefficient : h;//最大高度
        h = h < tvHeight*HeightCoefficient ? tvHeight*HeightCoefficient : h;//最小高度
        //reframe
        NSLog(@"chatHeight == %f",h);
        [_chatTV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h);
        }];
        self.chatTVHeight = h;
    }
    
    return YES;
}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    //编辑结束，chatTV恢复默认高度
//    [_chatTV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(tvHeight*HeightCoefficient);
//    }];
//}
#pragma mark ===== tool  =====
- (CGSize)sizeWithText:(NSString *)strText fontSize:(NSInteger)fontSize
{
    CGSize textMinSize = {tvWith, CGFLOAT_MAX};
    CGSize retSize;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];//调整行间距
    
    retSize = [strText boundingRectWithSize:textMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{
                                              NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                              NSParagraphStyleAttributeName:paragraphStyle
                                              }
                                    context:nil].size;
    return CGSizeMake(ceilf(retSize.width), ceilf(retSize.height));
}
-(void)dealloc
{
    [_chatTV resignFirstResponder];
}
@end
