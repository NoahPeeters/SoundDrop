//
//  ChannelSet.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Foundation

public class ChannelSet {
    internal private(set) var channels: [SoundCommChannel] = []

    public func register(channel: SoundCommChannel) {
        channels.append(channel)
    }

    public func unregister(channel: SoundCommChannel) {
        if let index = channels.firstIndex(where: { $0 === channel }) {
            channels.remove(at: index)
        }
    }
}
