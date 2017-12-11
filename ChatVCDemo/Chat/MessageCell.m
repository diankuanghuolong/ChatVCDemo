//
//  MessageCell.m
//  DHSeller
//
//  Created by Ios_Developer on 2017/12/6.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "MessageCell.h"
#import "Masonry.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define GREEN_COLOR [UIColor colorWithRed:208/255.0 green:241/255.0 blue:186/255.0 alpha:1]

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
       
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_offset(40);
        
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerIV.mas_right).offset(10);
        make.top.equalTo(_headerIV.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_nameL.mas_right).offset(5);
        make.top.equalTo(_nameL.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.bottom.equalTo(_nameL.mas_bottom);
    }];
    
    [triangleIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerIV.mas_right).offset(10);
        make.top.equalTo(_nameL.mas_bottom).offset(10);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerIV.mas_right).offset(20);
        make.top.equalTo(_nameL.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [_messageL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(_messageView);
        make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
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
       
        make.left.equalTo(weakSelf.contentView.mas_right).offset(- 55);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_nameL.mas_left).offset(-10);
        make.top.equalTo(_headerIV.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_nameL.mas_left).offset(-5);
        make.top.equalTo(_nameL.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [triangleIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_headerIV.mas_left).offset(-10);
        make.top.equalTo(_nameL.mas_bottom).offset(10);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_headerIV.mas_left).offset(-20);
        make.top.equalTo(_nameL.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [_messageL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(_messageView);
        make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
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
        CGFloat nameLW = [self sizeForLableWithText:_nameL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, _nameL.frame.size.height)].width + 6;
        nameLW = nameLW < 40 ? 40 : nameLW;
        
        __weak typeof(self) weakSelf = self;
        [_nameL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(_headerIV.mas_right).offset(10);
            make.top.equalTo(_headerIV.mas_top);
            make.width.mas_equalTo(nameLW);
            make.height.mas_equalTo(20);
        }];
        
        //timeL refame
        [_timeL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(_nameL.mas_right).offset(5);
            make.top.equalTo(_nameL.mas_top);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.bottom.equalTo(_nameL.mas_bottom);
        }];
        
        //messageView messageL reframe
        [self layoutIfNeeded];
        CGFloat messageW = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, 40)].width + 6 + 30;
        messageW = messageW > SCREEN_WIDTH - _headerIV.frame.size.width - 30 - 20 ? SCREEN_WIDTH - _headerIV.frame.size.width - 30 - 20 : messageW;
        
        CGFloat messageH = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(messageW, MAXFLOAT)].height + 20 + 20;
        messageH = messageH < 40 ? 40 : messageH;
        
        [_messageView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(_headerIV.mas_right).offset(20);
            make.top.equalTo(_nameL.mas_bottom).offset(10);
            make.width.mas_equalTo(messageW);
            make.height.mas_equalTo(messageH);
        }];
        
        [_messageL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.center.equalTo(_messageView);
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
        //马上刷新
        [self layoutIfNeeded];
        
        
    }
    else//自己
    {
        //nameL 宽修改
        CGFloat nameLW = [self sizeForLableWithText:_nameL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, _nameL.frame.size.height)].width + 6;
        nameLW = nameLW < 40 ? 40 : nameLW;
        
        [_nameL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(_headerIV.mas_left).offset(- 10);
            make.top.equalTo(_headerIV.mas_top);
            make.width.mas_equalTo(nameLW);
            make.height.mas_equalTo(20);
        }];
        
        __weak typeof(self) weakSelf = self;
        //timeL refame
        [_timeL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(_nameL.mas_top);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(_nameL.mas_left).offset(-5);
            make.height.mas_equalTo(20);
        }];
        
        //messageView messageL reframe
        [self layoutIfNeeded];
        CGFloat messageW = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(MAXFLOAT, 40)].width + 6 + 30;
        
        messageW = messageW > SCREEN_WIDTH - _headerIV.frame.size.width - 30 - 20 ? SCREEN_WIDTH - _headerIV.frame.size.width - 30 - 20 : messageW;
        
        CGFloat messageH = [self sizeForLableWithText:_messageL.text fontSize:12 withSize:CGSizeMake(messageW, MAXFLOAT)].height + 20 + 20;
        messageH = messageH < 40 ? 40 : messageH;
        
        [_messageView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(_headerIV.mas_left).offset(-20);
            make.top.equalTo(_nameL.mas_bottom).offset(10);
            make.width.mas_equalTo(messageW);
            make.height.mas_equalTo(messageH);
        }];
        
        [_messageL mas_updateConstraints:^(MASConstraintMaker *make) {

            make.center.equalTo(_messageView);
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
        //马上更新
        [self layoutIfNeeded];
    }
    
}
-(CGFloat)getCellHeight
{
    CGFloat h = CGRectGetMaxY(_messageView.frame) + 10;
    return h;
}

#pragma mark  ===== tools =====
-(CGSize) sizeForLableWithText:(NSString *)strText fontSize:(NSInteger)fontSize withSize:(CGSize)size
{
    CGSize textSize;
    if (!strText) strText = @"";
    NSString *s = strText;
    NSAttributedString *attrStr = [[NSAttributedString  alloc] initWithString:s];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSMutableDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range].mutableCopy;
//    NSDictionary *dic1 =@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:fontSize]};// 获取该段attributedString的属性字典1
    NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    [dic addEntriesFromDictionary:dic1];


    // 计算文本的大小
    textSize = [s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                            attributes:dic        // 文字的属性
                               context:nil].size;
    return textSize;
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
