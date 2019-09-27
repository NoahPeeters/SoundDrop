//
//  SoundCommSocket.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Foundation

public class SoundCommSocket {
    public typealias TransmitCallback = (SoundCommSocketTransmitError?) -> Void

    private let soundCommTransmitter: SoundCommTransmitter

    public init(soundCommTransmitter: SoundCommTransmitter) {
        self.soundCommTransmitter = soundCommTransmitter
    }

    public func start() {
        self.soundCommTransmitter.startTransmitting()
    }
}
