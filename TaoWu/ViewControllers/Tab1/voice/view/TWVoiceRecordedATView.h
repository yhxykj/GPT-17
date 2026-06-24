//
//  TWVoiceRecordedATView.h
//  TaoWu
//
//  Created by JJK on 2023/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWVoiceRecordedATViewDelegate <NSObject>

- (void)_thisRecordingHasBeenCompleted;

@end

@interface TWVoiceRecordedATView : UIView
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (weak, nonatomic) IBOutlet UILabel *tw_status_label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tw_record_image_height1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tw_record_image_height2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tw_record_image_height3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tw_record_image_height4;

@property (weak, nonatomic) IBOutlet UIImageView *record_image1;
@property (weak, nonatomic) IBOutlet UIImageView *record_image2;
@property (weak, nonatomic) IBOutlet UIImageView *record_image3;
@property (weak, nonatomic) IBOutlet UIImageView *record_image4;

@property (nonatomic, weak) id<TWVoiceRecordedATViewDelegate> delegate;


@property (nonatomic, copy)  NSString *tw_outputPath;

- (void)tw_recordVoice;


- (void)tw_stopRecorder;

//- (void)tw_playerVoiceStatus;

//- (void)tw_createPlayerTimer;

//- (void)getCurrentVolume; /// 获取播放时声音的大小

@end

NS_ASSUME_NONNULL_END
