//
//  TWDaAnTableViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import "TWDaAnTableViewCell.h"

@interface TWDaAnTableViewCell ()

@end

@implementation TWDaAnTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)tw_choosedefaultQuestionAction:(UIButton *)sender {
    NSArray *array = @[@"如何向你提问，有哪些主要注意的地方？",
                       @"如何克服拖延症以及提高自我管理能力？",
                       @"有什么简便的健身方法可以在家中进行？",
                       @"如何在家中创造一个舒适和温馨的环境？",
                       @"如何尊重和支持对方的个人成长和发展？",
                       @"什么是气候变化，它对地球有哪些影响？"];
    
    if (self.sendDefaultQuestionBlock) {
        self.sendDefaultQuestionBlock(array[sender.tag]);
    }
    
}

@end
