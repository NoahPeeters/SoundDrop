//
//  Optional+valueOrThrow.swift
//  SoundComm
//
//  Created by Noah Peeters on 09.05.19.
//  Copyright © 2019 Blechschmidt & Peeters. All rights reserved.
//

import Foundation

extension Optional {
    internal func valueOrThrow(_ error: Error) throws -> Wrapped {
        switch self {
        case let .some(value):
            return value
        case .none:
            throw error
        }
    }
}
