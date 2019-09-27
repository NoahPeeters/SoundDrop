//
//  SoundCommTransmitterInputBuffer.swift
//  SoundCommTests
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Nimble
import Quick
@testable import SoundComm

public class SoundCommTransmitterInputBufferSpec: QuickSpec {
    override public func spec() {
        describe("SoundCommTransmitterInputBuffer") {
            var buffer: SoundCommTransmitterBuffer!

            beforeEach {
                buffer = SoundCommTransmitterBuffer()
            }

            context("with no data") {
                it("does not return data") {
                    expect(buffer.getNextBit()).to(beNil())
                }
            }

            context("with one byte") {
                it("does return the first byte correctly") {
                    buffer.enqueue(data: [0xD6])

                    var data: Byte = 0
                    while let bit = buffer.getNextBit() {
                        data = (data << 1) | bit
                    }

                    expect(data).to(equal(0xD6))
                    expect(buffer.getNextBit()).to(beNil())
                }
            }

            context("with two byte") {
                it("does return the first two byte correctly") {
                    buffer.enqueue(data: [0xD6, 0xF2])

                    var data: Int = 0
                    while let bit = buffer.getNextBit() {
                        data = (data << 1) | Int(bit)
                    }

                    expect(data).to(equal(0xD6F2))
                    expect(buffer.getNextBit()).to(beNil())
                }
            }

            context("with two byte and adding one later") {
                it("does return the first three byte correctly") {
                    buffer.enqueue(data: [0xD6, 0xF2])

                    var data: Int = 0
                    for _ in 0..<10 {
                        let bit = buffer.getNextBit()
                        expect(bit).toNot(beNil())
                        data = (data << 1) | Int(bit!)
                    }

                    buffer.enqueue(data: [0x42])

                    while let bit = buffer.getNextBit() {
                        data = (data << 1) | Int(bit)
                    }

                    expect(data).to(equal(0xD6F242))
                    expect(buffer.getNextBit()).to(beNil())
                }
            }
        }
    }
}
