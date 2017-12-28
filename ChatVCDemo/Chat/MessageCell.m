//
//  MessageCell.m
//  DHSeller
//
//  Created by Ios_Developer on 2017/12/6.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "MessageCell.h"
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

#define GREEN_COLOR [UIColor colorWithRed:208/255.0 green:241/255.0 blue:186/255.0 alpha:1]
#define MAX_MessageL SCREEN_WIDTH - (40 + 30 + 20)*WidthCoefficient

@interface MessageCell()

@property(nonatomic,strong)UIPasteboard * pasteboard;//粘贴板
@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //默认样式
    [self loadOtherCell];
    
    self.pasteboard = [UIPasteboard generalPasteboard];
    
    return self;
}

#pragma mark ===== loadViews =====
-(void)loadOtherCell
{
    //headerIV
    _headerIV = [[UIImageView alloc] init];
    _headerIV.backgroundColor = [UIColor whiteColor];
    _headerIV.layer.cornerRadius = 7;
    _headerIV.layer.masksToBounds = YES;
    [self.contentView addSubview:_headerIV];
    
    //nameL,timeL
    _nameL = [[UILabel alloc] init];
    _nameL.textColor = [UIColor colorWithRed:57/255.0 green:54/255.0 blue:43/255.0 alpha:1];
    _nameL.textAlignment = NSTextAlignmentLeft;
    _nameL.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameL];
    
    _timeL = [[UILabel alloc] init];
    _timeL.textColor = [UIColor colorWithRed:197/255.0 green:195/255.0 blue:187/255.0 alpha:1];
    _timeL.font = [UIFont systemFontOfSize:12];
    _timeL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timeL];
    
    //messageView
    _messageView = [[UIView alloc] init];
    _messageView.backgroundColor = [UIColor whiteColor];
    _messageView.layer.cornerRadius = 10;
    _messageL.layer.masksToBounds = YES;
    [self.contentView addSubview:_messageView];
    
    UIImageView *triangleIV = [[UIImageView alloc] init];
    triangleIV.image = [UIImage imageNamed:@"chatImg"];
    [self.contentView addSubview:triangleIV];
    
    _messageL = [[UILabel alloc] init];
    _messageL.textColor = GREEN_COLOR;
    _messageL.font = [UIFont systemFontOfSize:12];
    _messageL.textAlignment = NSTextAlignmentLeft;
    _messageL.textColor = [UIColor colorWithRed:57/255.0 green:54/255.0 blue:43/255.0 alpha:1];
    _messageL.numberOfLines = 0;
    _messageL.layer.cornerRadius = 10;
    _messageL.layer.masksToBounds = YES;
    _messageL.userInteractionEnabled = YES;
    [_messageView addSubview:_messageL];
    
    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHandle:)];
    [_messageL addGestureRecognizer:longGR];
    
    __weak typeof(self) weakSelf = self;
    [_headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WidthCoefficient);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10*HeightCoefficient);
        make.width.mas_equalTo(40*HeightCoefficient);
        make.height.mas_offset(40*HeightCoefficient);
        
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerIV.mas_right).offset(10*WidthCoefficient);
        make.top.equalTo(_headerIV.mas_top);
        make.width.mas_equalTo(60*WidthCoefficient);
        make.height.mas_equalTo(20*HeightCoefficient);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_nameL.mas_right).offset(5*WidthCoefficient);
        make.top.equalTo(_nameL.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15*WidthCoefficient);
        make.bottom.equalTo(_nameL.mas_bottom);
    }];
    
    [triangleIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerIV.mas_right).offset(10*WidthCoefficient);
        make.top.equalTo(_nameL.mas_bottom).offset(10*HeightCoefficient);
        make.width.mas_equalTo(10*HeightCoefficient);
        make.height.mas_equalTo(10*HeightCoefficient);
    }];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerIV.mas_right).offset(20*WidthCoefficient);
        make.top.equalTo(_nameL.mas_bottom).offset(10*HeightCoefficient);
        make.width.mas_equalTo(60*WidthCoefficient);
        make.height.mas_equalTo(40*HeightCoefficient);
    }];
    
    [_messageL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(_messageView);
        make.edges.mas_offset(UIEdgeInsetsMake(10*HeightCoefficient, 15*WidthCoefficient, 10*HeightCoefficient, 15*WidthCoefficient));
    }];
}
-(void)loadSelfCell
{
//    CGRectMake(15, 10, 40, 40)
    //headerIV
    _headerIV = [[UIImageView alloc] init];
    _headerIV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_headerIV];
    
    //nameL,timeL
    _nameL = [[UILabel alloc] init];
    _nameL.textColor = [UIColor colorWithRed:57/255.0 green:54/255.0 blue:43/255.0 alpha:1];
    _nameL.textAlignment = NSTextAlignmentRight;
    _nameL.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameL];

    _timeL = [[UILabel alloc] init];
    _timeL.textColor = [UIColor colorWithRed:197/255.0 green:195/255.0 blue:187/255.0 alpha:1];
    _timeL.font = [UIFont systemFontOfSize:12];
    _timeL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeL];
    
    //messageView
    _messageView = [[UIView alloc] init];
    _messageView.backgroundColor = GREEN_COLOR;
    _messageView.layer.cornerRadius = 10;
    _messageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_messageView];
    
    UIImageView *triangleIV = [[UIImageView alloc] init];
    triangleIV.image = [UIImage imageNamed:@"chatImg"];
    [self.contentView addSubview:triangleIV];
    
    _messageL = [[UILabel alloc] init];
    _messageL.textColor = GREEN_COLOR;
    _messageL.font = [UIFont systemFontOfSize:12];
    _messageL.textAlignment = NSTextAlignmentLeft;
    _messageL.textColor = [UIColor colorWithRed:57/255.0 green:54/255.0 blue:43/255.0 alpha:1];
    _messageL.numberOfLines = 0;
    _messageL.layer.cornerRadius = 7;
    _messageL.layer.masksToBounds = YES;
    _messageL.userInteractionEnabled = YES;
    [_messageView addSubview:_messageL];
    
    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHandle:)];
    [_messageL addGestureRecognizer:longGR];
    
    __weak typeof(self) weakSelf = self;
    [_headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.contentView.mas_right).offset(- 55*WidthCoefficient);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10*HeightCoefficient);
        make.width.mas_equalTo(40*HeightCoefficient);
        make.height.mas_equalTo(40*HeightCoefficient);
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_nameL.mas_left).offset(-10*WidthCoefficient);
        make.top.equalTo(_headerIV.mas_top);
        make.width.mas_equalTo(60*WidthCoefficient);
        make.height.mas_equalTo(20*HeightCoefficient);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_nameL.mas_left).offset(-5*WidthCoefficient);
        make.top.equalTo(_nameL.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WidthCoefficient);
        make.height.mas_equalTo(20*HeightCoefficient);
    }];
    
    [triangleIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_headerIV.mas_left).offset(-10*WidthCoefficient);
        make.top.equalTo(_nameL.mas_bottom).offset(10*HeightCoefficient);
        make.width.mas_equalTo(10*HeightCoefficient);
        make.height.mas_equalTo(10*HeightCoefficient);
    }];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_headerIV.mas_left).offset(-20*WidthCoefficient);
        make.top.equalTo(_nameL.mas_bottom).offset(10*HeightCoefficient);
        make.width.mas_equalTo(60*WidthCoefficient);
        make.height.mas_equalTo(40*HeightCoefficient);
    }];
    
    [_messageL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(_messageView);
        make.edges.mas_offset(UIEdgeInsetsMake(10*HeightCoefficient, 15*WidthCoefficient, 10*HeightCoefficient, 15*WidthCoefficient));
    }];
}

#pragma mark  ===== action  =====
-(void)getMessage:(NSDictionary *)messageDic
{
    for (UIView *view in self.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (self)
    {
        if (self.type == 0)//对方
            [self loadOtherCell];
        else//自己
            [self loadSelfCell];
    }
    _messageL.text = messageDic[@"mess"];
    _nameL.text = messageDic[@"name"];
    _timeL.text = messageDic[@"time"];
}
-(void)reframe
{
    if (self.type == 0)//对方
    {
        //nameL 宽修改
//        CGFloat nameLW = [self sizeForLableWithText:_nameL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, _nameL.frame.size.height)].width + 6;
        CGFloat nameLW = [self sizeWithText:_nameL.text fontSize:12].width + 6*WidthCoefficient;
        nameLW = nameLW < 40*WidthCoefficient ? 40*WidthCoefficient : nameLW;
        
        __weak typeof(self) weakSelf = self;
        [_nameL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(_headerIV.mas_right).offset(10*WidthCoefficient);
            make.top.equalTo(_headerIV.mas_top);
            make.width.mas_equalTo(nameLW);
            make.height.mas_equalTo(20*HeightCoefficient);
        }];
        
        //timeL refame
        [_timeL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(_nameL.mas_right).offset(5*WidthCoefficient);
            make.top.equalTo(_nameL.mas_top);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15*WidthCoefficient);
            make.bottom.equalTo(_nameL.mas_bottom);
        }];
        
        //messageView messageL reframe
        [self layoutIfNeeded];
//        CGFloat messageW = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, 40)].width + 6 + 30;
        CGFloat messageW = [self sizeWithText:_messageL.text fontSize:12].width + 36 *WidthCoefficient;
        messageW = messageW > MAX_MessageL  ?MAX_MessageL : messageW;
        
//        CGFloat messageH = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(messageW, MAXFLOAT)].height + 20 + 20;
        CGFloat messageH = [self sizeWithText:_messageL.text fontSize:12].height + 40*HeightCoefficient;
        messageH = messageH < 40*HeightCoefficient ? 40*HeightCoefficient : messageH;
        
        [_messageView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(_headerIV.mas_right).offset(20*WidthCoefficient);
            make.top.equalTo(_nameL.mas_bottom).offset(10*HeightCoefficient);
            make.width.mas_equalTo(messageW);
            make.height.mas_equalTo(messageH);
        }];
        
        [_messageL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.center.equalTo(_messageView);
            make.edges.mas_offset(UIEdgeInsetsMake(10*HeightCoefficient, 15*WidthCoefficient, 10*HeightCoefficient, 15*WidthCoefficient));
        }];
        
        //马上刷新
        [self layoutIfNeeded];
        
        
    }
    else//自己
    {
        //nameL 宽修改
//        CGFloat nameLW = [self sizeForLableWithText:_nameL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, _nameL.frame.size.height)].width + 6;
        CGFloat nameLW = [self sizeWithText:_nameL.text fontSize:12].width + 6*WidthCoefficient;
        nameLW = nameLW < 40*HeightCoefficient ? 40*HeightCoefficient : nameLW;
        
        [_nameL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(_headerIV.mas_left).offset(- 10*WidthCoefficient);
            make.top.equalTo(_headerIV.mas_top);
            make.width.mas_equalTo(nameLW);
            make.height.mas_equalTo(20*HeightCoefficient);
        }];
        
        __weak typeof(self) weakSelf = self;
        //timeL refame
        [_timeL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(_nameL.mas_top);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WidthCoefficient);
            make.right.equalTo(_nameL.mas_left).offset(-5*WidthCoefficient);
            make.height.mas_equalTo(20*HeightCoefficient);
        }];
        
        //messageView messageL reframe
        [self layoutIfNeeded];
//        CGFloat messageW = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, 40)].width + 6 + 30;
        CGFloat messageW = [self sizeWithText:_messageL.text fontSize:12].width + 36 *HeightCoefficient;
        
        messageW = messageW > MAX_MessageL ? MAX_MessageL : messageW;
        
//        CGFloat messageH = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(messageW, MAXFLOAT)].height + 20 + 20;
        CGFloat messageH = [self sizeWithText:_messageL.text fontSize:12].height + 40 *HeightCoefficient;
        messageH = messageH < 40*HeightCoefficient ? 40*HeightCoefficient : messageH;
        
        [_messageView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(_headerIV.mas_left).offset(-20*WidthCoefficient);
            make.top.equalTo(_nameL.mas_bottom).offset(10*HeightCoefficient);
            make.width.mas_equalTo(messageW);
            make.height.mas_equalTo(messageH);
        }];
        
        [_messageL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.center.equalTo(_messageView);
            make.edges.mas_offset(UIEdgeInsetsMake(10*HeightCoefficient, 15*WidthCoefficient, 10*HeightCoefficient, 15*WidthCoefficient));
        }];
        
        //马上更新
        [self layoutIfNeeded];
    }
    
}
-(CGFloat)getCellHeight
{
    CGFloat h = CGRectGetMaxY(_messageView.frame) + 10*HeightCoefficient;
    return h;
}

#pragma mark  ===== tools =====
- (CGSize)sizeWithText:(NSString *)strText fontSize:(NSInteger)fontSize
{
    CGSize textMinSize = {MAX_MessageL, CGFLOAT_MAX};
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

//----- 粘贴板事件
- (void)longHandle:(UILongPressGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
//        [_messageL becomeFirstResponder]; 在cell中给messageL变为第一响应，menuC不显示
        [self becomeFirstResponder];
        
        UIMenuController * menuC = [UIMenuController sharedMenuController];
        
        //当长按label的时候，这个方法会不断调用，menu就会出现一闪一闪不断显示，需要在此处进行判断
        if (menuC.isMenuVisible)return;
        
        //copy
        UIMenuItem * copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyToPasteboard:)];
        //cut
        UIMenuItem * cutLink = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(cutToPasteboard:)];
        
        UIMenuItem * pasteLink = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(pasteToPasteboard:)];
        
        [menuC setMenuItems:@[copyLink,cutLink,pasteLink]];
        [menuC setTargetRect:_messageL.frame inView:_messageL.superview];
        [menuC setMenuVisible:YES animated:YES];
        
        NSLog(@"%@",NSStringFromCGRect(menuC.menuFrame));
    }
}

//复制
- (void)copyToPasteboard:(id)sender
{
    if (_messageL.text != nil)
    {
        _pasteboard.string = _messageL.text;
    }
    else return;
}

//剪切
- (void)cutToPasteboard:(id)sender
{
    if (_messageL.text != nil)
    {
        
        //        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        _pasteboard.string = _messageL.text;
        _messageL.text = nil;
    }
    else return;
}

//粘贴
- (void)pasteToPasteboard:(id)sender
{
    _messageL.text = self.pasteboard.string;
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyToPasteboard:))
    {
        return YES;
    }
    if (action == @selector(cutToPasteboard:))
    {
        return YES;
    }
    if (action == @selector(pasteToPasteboard:))
    {
        return YES;
    }
    return NO;
}

@end
