//
//  TWHuiDaTableViewCell.swift
//  TaoWu
//
//  Created by JJK on 2023/12/28.
//

import UIKit
import SVProgressHUD
import MarkdownKit

@objc protocol TWHuiDaTableViewCellDelegate: AnyObject {
    func tw_deleteTWDaAnTableViewCell(_ cell: TWHuiDaTableViewCell)
}

class TWHuiDaTableViewCell: UITableViewCell {

    @objc weak var delegate: TWHuiDaTableViewCellDelegate?
    
    @IBOutlet weak var tw_content_label: UITextView!
    @IBOutlet weak var tw_sy_button: UIButton!
    
    var speedSynthesis = TWSpeechSynthesisManager.shared()
    var tw_timer: Timer!
    var tw_sum = 0
    var tw_selectIndex = 0
    
    deinit {
        if let timer = self.tw_timer {
            timer.invalidate()
            self.tw_timer = nil
        }
        self.speedSynthesis.tw_stopPlayerVoice()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.speedSynthesis.initNuiTts()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func tw_setCellData(_ cell_dic: NSDictionary) {
        
        self.tw_content_label.text = cell_dic.object(forKey: "message") as? String
        
        let content = cell_dic.object(forKey: "message") as? String
         
        tw_content_label.attributedText = markdownParser.parse(content!)
        
    }
    
    @IBAction func tw_deleteButtonAction(_ sender: UIButton) {
        delegate?.tw_deleteTWDaAnTableViewCell(self)
    }
    
    @IBAction func tw_fuzhiButtonAction(_ sender: UIButton) {

        let pasteboard = UIPasteboard.general
        pasteboard.string = self.tw_content_label.text
        SVProgressHUD.showSuccess(withStatus: "复制成功！")
        
    }
    
    @IBAction func tw_bfButtonAction(_ sender: UIButton) {
        
        if sender.tag == self.tw_selectIndex {
            if sender.isSelected { // 阅读
                sender.isSelected = false
            }
            else {
                self.speedSynthesis.tw_stopPlayerVoice()
                sender.isSelected = true
                recoverButtonStatus()
               return
            }
        }
        
        self.tw_selectIndex = sender.tag

        // 发送通知是点击的那一个cell上的button
        NotificationCenter.default.post(name: NSNotification.Name("recoverButton"), object: nil)
        
        self.speedSynthesis.tw_stopPlayerVoice()
        self.speedSynthesis.tw_playerVoice(self.tw_content_label.text)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(voiceSpeedplayDoneAction), name: NSNotification.Name("voiceSpeedplayDoneNotificationName"), object: nil)
        
        
        self.tw_newCreateCellTimer()
        
        
    }
    
    func tw_newCreateCellTimer() {

        NotificationCenter.default.addObserver(self, selector: #selector(recoverButtonStatus), name: NSNotification.Name("recoverButton"), object: nil)
        
        tw_timer = Timer.scheduledTimer(timeInterval: 0.31, target: self, selector: #selector(onActivateTimerClick), userInfo: nil, repeats: true)
    }
    
    @objc func _demonstrationAction() {
        self.speedSynthesis.initNuiTts()
        self.speedSynthesis.tw_playerVoice(self.tw_content_label.text)
    }
    
    @objc func recoverButtonStatus() {
        if tw_timer != nil {
            tw_timer.invalidate()
            tw_timer = nil;
        }
        self.tw_sy_button.setImage(UIImage(named: "dh_sy_3"), for: .normal)
    }
    
    @objc func voiceSpeedplayDoneAction() {
        
        DispatchQueue.main.async {
            if self.tw_timer != nil {
                self.tw_timer.invalidate()
                self.tw_timer = nil;
            }
            self.tw_sy_button.setImage(UIImage(named: "dh_sy_3"), for: .normal)
        }
    }
    
    @objc func onActivateTimerClick() {
        
        if self.tw_sum == 3 {
            self.tw_sum = 0;
        }
        
        self.tw_sum = self.tw_sum + 1;
        
        self.tw_sy_button.setImage(UIImage(named: "dh_sy_\(self.tw_sum)"), for: .normal)
        
    }
    
    private lazy var markdownParser = {
        let markdown = MarkdownParser(font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular), color: UIColor.black)
        markdown.code.font = UIFont(name: "Menlo", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        markdown.code.textHighlightColor = UIColor.black
//        markdown.code.textBackgroundColor = UIColor.yellow
        markdown.code.textBackgroundColor = self.UIColorFromRGB(0x6BACFE).withAlphaComponent(0.3)
//        UIColor(hex: "6BACFE").withAlphaComponent(0.1)
        return markdown
    }()

    
    
    func UIColorFromRGB(_ rgbValue: UInt32) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
