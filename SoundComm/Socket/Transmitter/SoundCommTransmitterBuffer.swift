//
//  SoundCommTransmitterInputBuffer.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Foundation

internal class SoundCommTransmitterBuffer {
    private var buffer: [Byte] = []
    private var currentByte: Byte = 0
    private var currentByteIndex: Int = -1

    internal func getNextBit() -> Byte? {
        if currentByteIndex < 0 {
            guard let nextByte = buffer.popLast() else {
                return nil
            }

            currentByte = nextByte
            currentByteIndex = 7
        }

        defer {
            currentByteIndex -= 1
        }

        return (currentByte >> currentByteIndex) & 1
    }

    internal func enqueue(data: [Byte]) {
        buffer = data.reversed() + buffer
    }
}
