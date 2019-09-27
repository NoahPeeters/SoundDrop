//
//  SoundCommFMTransmitterError.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Foundation

public enum SoundCommFMTransmitterError: Error {
    case cannotCreateAudioBuffer
    case cannotCreateAudioFormat
}
