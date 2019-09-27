//
//  SoundCommFMTransmitter.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import AVFoundation

public class SoundCommFMTransmitter: SoundCommTransmitter {
    // The audio engine manages the sound system.
    private let engine: AVAudioEngine = AVAudioEngine()

    // The player node schedules the playback of the audio buffers.
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()

    // Use standard non-interleaved PCM audio.
    private let audioFormat: AVAudioFormat

    // A circular queue of audio buffers.
    private let audioBuffers: [AVAudioPCMBuffer]

    // Size of individual audio buffer
    private let audioBufferSize: AVAudioFrameCount

    // The index of the next buffer to fill.
    private var bufferIndex: Int = 0

    // The dispatch queue to render audio samples.
    private let audioQueue = DispatchQueue(label: "SoundCommFMTransmitterQueue", qos: .default)

    // A semaphore to gate the number of buffers processed.
    private let audioSemaphore: DispatchSemaphore

    public let channelSet = ChannelSet()

    public init(audioBufferCount: Int = 2, audioBufferSize: AVAudioFrameCount = 22050) throws { // 1024
        self.audioBufferSize = audioBufferSize
        self.audioSemaphore = DispatchSemaphore(value: audioBufferCount)

        self.audioFormat = try AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2).valueOrThrow(SoundCommFMTransmitterError.cannotCreateAudioFormat)
        self.audioBuffers = try SoundCommFMTransmitter.generateAudioBuffers(forPCMFormat: audioFormat, frameCapacity: audioBufferSize, count: audioBufferCount)

        // Attach and connect the player node.
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: audioFormat)

        try engine.start()
    }

    private static func generateAudioBuffers(forPCMFormat pcmFormat: AVAudioFormat, frameCapacity: AVAudioFrameCount, count: Int) throws -> [AVAudioPCMBuffer] {
        var audioBuffers = [AVAudioPCMBuffer]()
        for _ in 0..<count {
            guard let buffer = AVAudioPCMBuffer(pcmFormat: pcmFormat, frameCapacity: frameCapacity) else {
                throw SoundCommFMTransmitterError.cannotCreateAudioBuffer
            }
            audioBuffers.append(buffer)
        }

        return audioBuffers
    }

    public func startTransmitting() {
        let sampleRate = Float(audioFormat.sampleRate)
        let unitVelocity = 2 * Float.pi / sampleRate

        audioQueue.async {
            var sampleTime: Float = 0

            while true {
                self.audioSemaphore.wait()

                let audioBuffer = self.audioBuffers[self.bufferIndex]
                guard let leftChannel = audioBuffer.floatChannelData?[0], let rightChannel = audioBuffer.floatChannelData?[1] else {
                    NSLog("Failed!")
                    return
                }

                let frequencies = self.channelSet.channels.compactMap { $0.nextSendFrequency() }
                let velocities = frequencies.map { $0 * unitVelocity }

                for sampleIndex in 0..<Int(self.audioBufferSize) {
                    let sample = velocities.reduce(0) { $0 + sin($1 * sampleTime) }
                    leftChannel[sampleIndex] = sample
                    rightChannel[sampleIndex] = sample
                    sampleTime += 1
                }

                audioBuffer.frameLength = self.audioBufferSize

                self.playerNode.scheduleBuffer(audioBuffer) {
                    self.audioSemaphore.signal()
                }

                self.bufferIndex = (self.bufferIndex + 1) % self.audioBuffers.count
            }
        }

        playerNode.play()
    }
}
