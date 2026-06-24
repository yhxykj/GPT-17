//
//  TWCZEditorTextTableViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/20.
//

#import "TWCZEditorTextTableViewCell.h"

@interface TWCZEditorTextTableViewCell ()<UITextViewDelegate>

@end

@implementation TWCZEditorTextTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tw_textField setDelegate:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldDidChange:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)tw_clearButtonAction:(id)sender {
    self.tw_textField.text = @"";
    [self.delegate cell_tWCZEditorTextFieldTableViewCell:self];
}

- (void)tw_updateCellData:(NSDictionary *)param {
   
    self.tw_textField.text = @"";
    [self.cell_placeholder_label setHidden:NO];
    [self.cell_name_label setText:[param objectForKey:@"name"]];
    [self.cell_placeholder_label setText:[param objectForKey:@"content"]];
    
}

- (void)textFieldDidChange:(NSNotification *)notification {
    
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.tw_textField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell_tWCZEditorTextFieldTableViewCell:cellForContent:)]) {
            [self.delegate cell_tWCZEditorTextFieldTableViewCell:self.cell_name_label.text cellForContent:self.tw_textField.text];
        }
    }
    
    if ([GlobalVC IsNullString:self.tw_textField.text]) {
        [self.cell_placeholder_label setHidden:NO];
    }
    else {
        [self.cell_placeholder_label setHidden:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell_tWCZEditorTextFieldTableViewCell:)]) {
        [self.delegate cell_tWCZEditorTextFieldTableViewCell:self];
    }
}


@end
