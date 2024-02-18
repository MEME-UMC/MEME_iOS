//
//  ArtistProfileInfoBuilder.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation


final class ArtistProfileInfoBuilder {
    private var userId: Int = 0
    private var profileImg = ""
    private var nickName = ""
    private var gender = Gender.FEMALE
    private var introduction = ""
    private var workExperience = ""
    private var region: [String] = []
    private var specialization: [String] = []
    private var makeupLocation = ""
    private var shopLocation = ""
    private var week: [String] = []
    private var startTime = ""
    private var endTime = ""
    
    func userId(_ userId: Int) -> ArtistProfileInfoBuilder {
        self.userId = userId
        return self
    }
    
    func profileImg(_ profileImg: String) -> ArtistProfileInfoBuilder {
        self.profileImg = profileImg
        return self
    }
    
    func nickName(_ nickName: String) -> ArtistProfileInfoBuilder {
        self.nickName = nickName
        return self
    }
    
    func gender(_ gender: Gender) -> ArtistProfileInfoBuilder {
        self.gender = gender
        return self
    }
    
    func introduction(_ introduction: String) -> ArtistProfileInfoBuilder {
        self.introduction = introduction
        return self
    }
    
    func workExperience(_ workExperience: String) -> ArtistProfileInfoBuilder {
        self.workExperience = workExperience
        return self
    }
    
    func region(_ region: [String]) -> ArtistProfileInfoBuilder {
        self.region = region
        return self
    }
    
    func specialization(_ specialization: [String]) -> ArtistProfileInfoBuilder {
        self.specialization = specialization
        return self
    }
    
    func makeupLocation(_ makeupLocation: String) -> ArtistProfileInfoBuilder {
        self.makeupLocation = makeupLocation
        return self
    }
    
    func shopLocation(_ shopLocation: String) -> ArtistProfileInfoBuilder {
        self.shopLocation = shopLocation
        return self
    }
    
    func week(_ week: [String]) -> ArtistProfileInfoBuilder {
        self.week = week
        return self
    }
    
    func startTime(_ time: String) -> ArtistProfileInfoBuilder {
        self.startTime = time
        return self
    }
    func endTime(_ time: String) -> ArtistProfileInfoBuilder {
        self.endTime = time
        return self
    }
    
    func build() -> AtristProfileInfo {
        return AtristProfileInfo(
            userId: userId,
            profileImg: profileImg,
            nickName: nickName,
            gender: gender,
            introduction: introduction,
            workExperience: workExperience,
            region: region,
            specialization: specialization,
            makeupLocation: makeupLocation,
            shopLocation: shopLocation,
            week: week,
            startTiem: startTime,
            endTime: endTime
        )
    }
}

