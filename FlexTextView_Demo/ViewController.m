//
//  ViewController.m
//  FlexTextView_Demo
//
//  Created by admin on 16/6/24.
//  Copyright © 2016年 AlezJi. All rights reserved.
//http://www.jianshu.com/p/9e960757de86
//如何优雅的让UITextView根据输入文字实时改变高度


#define kScreenWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度
#define kScreenHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度



#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property(strong,nonatomic)NSMutableArray *dataArray;//tableView数据存放数组
@property(strong, nonatomic) UITextView * contentTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 下面这一段代码，笔者就不费口舌了，读者应该都看的懂，就是创建一个外观类似于UITextField的UITextView
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake((kScreenWidth-150)/2, kScreenHeight/4, 150, 39)];
    self.contentTextView .layer.cornerRadius = 4;
    self.contentTextView .layer.masksToBounds = YES;
    self.contentTextView .delegate = self;
    self.contentTextView .layer.borderWidth = 2;
    self.contentTextView .font = [UIFont systemFontOfSize:14];
    self.contentTextView .layer.borderColor = [[[UIColor redColor] colorWithAlphaComponent:0.4] CGColor];
    //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
    //屏蔽掉没发现有什么问题
//    self.contentTextView.textContainerInset = UIEdgeInsetsMake(10,0, 0, 0);
    [self.view addSubview:self.contentTextView ];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {//删除
        if (![textView.text isEqualToString:@""]) {//textview这个字符串不为空  就删除一个字符
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
        }else{   //如果是空的就删除一个空格
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        //添加
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    return YES;
}

//计算评论框文字的高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    //    float padding = 10.0;
    CGSize constraint = CGSizeMake(textView.contentSize.width, CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    //1.计算输入文字高度的方法,之所以返回的高度值加22是因为UITextView有一个初始的高度值40，但是输入第一行文字的时候文字高度只有18，所以UITextView的高度会发生变化，效果不太好
    float textHeight = size.size.height + 22.0;
    return textHeight;
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_contentTextView resignFirstResponder];
}
@end
