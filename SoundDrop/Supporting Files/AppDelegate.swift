//
//  AppDelegate.swift
//  SoundDrop
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import SoundComm
import UIKit

@UIApplicationMain
private class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var soundCommSocket: SoundCommSocket!

    var audioInput: TempiAudioInput!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()

//         wiftlint:disable:next force_try
//        let transmitter = try! SoundCommFMTransmitter()
//        soundCommSocket = SoundCommSocket(soundCommTransmitter: transmitter)
//        soundCommSocket.start()
//
//        let channel = SoundCommChannel(baseSendFrequency: 440, baseReceiveFrequency: 440)
//        channel.enqueue(data: Array(repeating: 0b10101010, count: 1))
//        transmitter.channelSet.register(channel: channel)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            channel.enqueue(data: Array(repeating: 0b10101010, count: 1))
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//            channel.enqueue(data: Array(repeating: 0b10101010, count: 1))
//        }
        return true

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let audioInputCallback: TempiAudioInputCallback = { (timeStamp, numberOfFrames, samples) -> Void in
            self.gotSomeAudio(timeStamp: Double(timeStamp), numberOfFrames: Int(numberOfFrames), samples: samples)
        }
        audioInput = TempiAudioInput(audioInputCallback: audioInputCallback, sampleRate: 44100, numberOfChannels: 1)
        audioInput.startRecording()
    }

    func gotSomeAudio(timeStamp: Double, numberOfFrames: Int, samples: [Float]) {
        let fft = TempiFFT(withSize: 256, sampleRate: 44100.0)
        fft.windowType = TempiFFTWindowType.hanning
        fft.fftForward(Array(samples[0..<256]))

        fft.calculateLinearBands(minFrequency: 6000, maxFrequency: 6000, numberOfBands: 1)
//        fft.calculateLogarithmicBands(minFrequency: 0, maxFrequency: fft.nyquistFrequency, bandsPerOctave: Int(7))

//        for
//        print(fft.bandMagnitudes)

//        fft.calculateLogarithmicBands(minFrequency: 0, maxFrequency: fft.nyquistFrequency, bandsPerOctave: 20)
        print(fft.bandMagnitudes[0] > 0.0001)
    }
}
