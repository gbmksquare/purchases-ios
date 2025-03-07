//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  DiagnosticsEventEncodingTests.swift
//
//  Created by Antonio Pallares on 6/3/25.

import Nimble
@testable import RevenueCat
import SnapshotTesting
import XCTest

private let dateFormatter = ISO8601DateFormatter.default

class DiagnosticsEventEncodingTests: TestCase {

    private let exampleEvent = DiagnosticsEvent(
       name: .httpRequestPerformed,
       properties: DiagnosticsEvent.Properties(
           verificationResult: "FAILED",
           endpointName: HTTPRequest.Path.logIn.name,
           responseTime: 3,
           storeKitVersion: .storeKit1,
           successful: true,
           responseCode: 200,
           backendErrorCode: 500,
           errorMessage: "OK",
           errorCode: 1,
           skErrorDescription: "test_skErrorDescription",
           etagHit: false,

           // Do not use more than 1 elements in sets for snapshot testing
           // as the order of elements is not defined
           requestedProductIds: ["test_product_id1"],
           notFoundProductIds: ["test_product_id2"],

           productId: "test_productId",
           promotionalOfferId: "promotionalOfferId",
           winBackOfferApplied: false,
           purchaseResult: .userCancelled,
           isRetry: true
       ),
       timestamp: dateFormatter.date(from: "2022-03-08T17:42:58Z")!
   )

    func testEncoding() {
        assertSnapshot(matching: self.exampleEvent, as: .backwardsCompatibleFormattedJson)
    }

    func testReencoding() {
        expect(try self.exampleEvent.encodeAndDecode()) == self.exampleEvent
    }

}
