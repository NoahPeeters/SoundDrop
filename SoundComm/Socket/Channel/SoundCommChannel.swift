//
//  SoundCommChannel.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Foundation

public class SoundCommChannel {
    internal let sendBuffer = SoundCommTransmitterBuffer()
    private let lowSendFrequency: Frequency
    private let lowReceiveFrequency: Frequency
    private let highSendFrequency: Frequency
    private let highReceiveFrequency: Frequency

    public init(baseSendFrequency: Frequency, baseReceiveFrequency: Frequency) {
        self.lowSendFrequency = baseSendFrequency
        self.lowReceiveFrequency = baseReceiveFrequency
        self.highSendFrequency = baseSendFrequency * 2
        self.highReceiveFrequency = baseReceiveFrequency * 2
    }

    internal func nextSendFrequency() -> Frequency? {
        return sendBuffer.getNextBit().map {
            $0 == 0 ? lowSendFrequency : highSendFrequency
        }
    }

    public func enqueue(data: [Byte]) {
        sendBuffer.enqueue(data: data)
    }
}
