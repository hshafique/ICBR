//
//  LectureData.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 8/31/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LectureData : NSObject {
    int lectureIndex_;
    NSString *lecturerName_;
    NSString *lecturePath_;
    NSString *lectureName_;
    NSString *lectureLength_;
    NSString *lecturePicture_;
    NSString *lectureList_;
    NSArray *seperatedLectureList_;
    NSMutableArray *rootArrayOfLectures;
    NSMutableArray *lectureSet1_;
    NSMutableArray *lectureSet2_;
    NSMutableArray *lectureSet3_;
    NSMutableArray *lectureSet4_;
    NSMutableArray *lectureSet5_;
    NSMutableArray *lectureSet6_;
    NSMutableArray *lectureSet7_;
    NSMutableArray *lectureSet8_;
    NSMutableArray *lectureSet9_;
    NSMutableArray *lectureSet10_;
    NSMutableArray *lectureSet11_;
    NSMutableArray *lectureSet12_;
    NSMutableArray *lectureSet13_;
    NSMutableArray *lectureSet14_;
    NSMutableArray *lectureSet15_;
    NSMutableArray *lectureSet16_;
    NSMutableArray *lectureSet17_;
    NSMutableArray *lectureSet18_;
    NSMutableArray *lectureSet19_;
    NSMutableArray *lectureSet20_;
    NSMutableArray *lectureSet21_;
    NSMutableArray *lectureSet22_;
    NSMutableArray *lectureSet23_;
    NSMutableArray *lectureSet24_;
    NSMutableArray *lectureSet25_;
    NSMutableArray *lectureSet26_;
    NSMutableArray *lectureSet27_;
    NSMutableArray *lectureSet28_;
    NSMutableArray *lectureSet29_;
    NSMutableArray *lectureSet30_;
    int numberOfLecturers_;
}

-(void)parseSeperatedLectureList;
-(int)getNumberOfLecturers;
-(NSString *)getLecturerNameForIndex:(int) lectureIndex;
-(int)getNumberOfLecturesForIndex:(int) lectureIndex;
-(NSString *)getLecturerPictureForIndex:(int) lectureIndex;
-(NSArray *)getLectureDataForIndex:(int) lectureIndex;
-(NSString *)getLecturePathForIndex:(int) lectureIndex;

@end
