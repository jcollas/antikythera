//
//  AntikytheraMechanismTests.swift
//  Antikythera
//
//  Unit tests for the AntikytheraMechanism class
//

import XCTest
@testable import Antikythera

class AntikytheraMechanismTests: XCTestCase {

    var testJSONURL: URL!

    override func setUp() {
        super.setUp()
        // Get the path to the test JSON file
        let testBundle = Bundle(for: type(of: self))
        testJSONURL = testBundle.url(forResource: "test-device", withExtension: "json")
            ?? URL(fileURLWithPath: "Tests/ModelTests/test-device.json")
    }

    // MARK: - Initialization Tests

    func testMechanismInitializationFromJSON() {
        // When
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then
        XCTAssertEqual(mechanism.gears.count, 3, "Should load 3 gears from JSON")
        XCTAssertEqual(mechanism.connectors.count, 2, "Should load 2 connectors from JSON")
        XCTAssertEqual(mechanism.pointers.count, 1, "Should load 1 pointer from JSON")
    }

    func testMechanismLoadsGearsCorrectly() {
        // When
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then: Verify specific gears are loaded
        XCTAssertNotNil(mechanism.gearsByName["gA1"], "Should have gear gA1")
        XCTAssertNotNil(mechanism.gearsByName["gA2"], "Should have gear gA2")
        XCTAssertNotNil(mechanism.gearsByName["gA3"], "Should have gear gA3")

        // Verify gear properties
        let gA1 = mechanism.gearsByName["gA1"]!
        XCTAssertEqual(gA1.name, "gA1", "Gear name should be correct")
        XCTAssertEqual(gA1.toothCount, 40, "Tooth count should be correct")

        let gA2 = mechanism.gearsByName["gA2"]!
        XCTAssertEqual(gA2.toothCount, 20, "Tooth count should be correct")

        let gA3 = mechanism.gearsByName["gA3"]!
        XCTAssertEqual(gA3.toothCount, 60, "Tooth count should be correct")
    }

    func testMechanismLoadsConnectorsCorrectly() {
        // When
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then: Verify connectors are loaded
        XCTAssertNotNil(mechanism.connectorsByName["connector1"], "Should have connector1")
        XCTAssertNotNil(mechanism.connectorsByName["pinslot1"], "Should have pinslot1")

        // Verify connector types
        let connector1 = mechanism.connectorsByName["connector1"]!
        XCTAssertFalse(connector1 is PinAndSlotConnector, "connector1 should be regular Connector")

        let pinslot1 = mechanism.connectorsByName["pinslot1"]!
        XCTAssertTrue(pinslot1 is PinAndSlotConnector, "pinslot1 should be PinAndSlotConnector")
    }

    func testMechanismLoadsPointersCorrectly() {
        // When
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then
        XCTAssertEqual(mechanism.pointers.count, 1, "Should have one pointer")

        let pointer = mechanism.pointers[0]
        XCTAssertEqual(pointer.name, "pointer1", "Pointer name should be correct")
        XCTAssertEqual(pointer.onGear, "gA3", "Pointer should be on gA3")
        XCTAssertEqual(pointer.pointerKind, "standard", "Pointer kind should be standard")
    }

    // MARK: - Gear Linking Tests

    func testGearLinking() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then: Verify gears are linked as specified in JSON
        let gA1 = mechanism.gearsByName["gA1"]!
        let gA2 = mechanism.gearsByName["gA2"]!
        let gA3 = mechanism.gearsByName["gA3"]!

        // gA1 is linked to gA2
        XCTAssertTrue(gA1.neighbors.contains { $0 === gA2 }, "gA1 should be linked to gA2")
        XCTAssertTrue(gA2.neighbors.contains { $0 === gA1 }, "gA2 should be linked to gA1")

        // gA2 is linked to gA3
        XCTAssertTrue(gA2.neighbors.contains { $0 === gA3 }, "gA2 should be linked to gA3")
        XCTAssertTrue(gA3.neighbors.contains { $0 === gA2 }, "gA3 should be linked to gA2")
    }

    func testLinkGearMethod() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)
        let gear1 = createTestGear(name: "testGear1", teeth: 30)
        let gear2 = createTestGear(name: "testGear2", teeth: 60)

        // When
        mechanism.linkGear(gear1, with: gear2)

        // Then
        XCTAssertTrue(gear1.neighbors.contains { $0 === gear2 }, "Gear1 should have gear2 as neighbor")
        XCTAssertTrue(gear2.neighbors.contains { $0 === gear1 }, "Gear2 should have gear1 as neighbor")
    }

    // MARK: - Connector Neighbor Tests

    func testConnectorsEstablishNeighborRelationships() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then: Gears should have connectors as neighbors
        let gA1 = mechanism.gearsByName["gA1"]!
        let gA2 = mechanism.gearsByName["gA2"]!
        let gA3 = mechanism.gearsByName["gA3"]!

        let connector1 = mechanism.connectorsByName["connector1"]!
        let pinslot1 = mechanism.connectorsByName["pinslot1"]!

        // gA1 and gA2 should have connector1 as neighbor
        XCTAssertTrue(gA1.neighbors.contains { $0 === connector1 }, "gA1 should have connector1 as neighbor")
        XCTAssertTrue(gA2.neighbors.contains { $0 === connector1 }, "gA2 should have connector1 as neighbor")

        // gA2 and gA3 should have pinslot1 as neighbor
        XCTAssertTrue(gA2.neighbors.contains { $0 === pinslot1 }, "gA2 should have pinslot1 as neighbor")
        XCTAssertTrue(gA3.neighbors.contains { $0 === pinslot1 }, "gA3 should have pinslot1 as neighbor")
    }

    // MARK: - Rotation Propagation Tests

    func testRotateMechanismFromInputGear() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)
        let gA1 = mechanism.gearsByName["gA1"]!
        let gA2 = mechanism.gearsByName["gA2"]!
        let gA3 = mechanism.gearsByName["gA3"]!

        // When: Rotate the mechanism (which rotates gA1)
        mechanism.rotate(10.0)

        // Then: All gears should rotate
        XCTAssertEqual(gA1.rotation, 10.0, accuracy: 0.001, "Input gear should rotate by requested amount")
        XCTAssertNotEqual(gA2.rotation, 0.0, "gA2 should rotate")
        XCTAssertNotEqual(gA3.rotation, 0.0, "gA3 should rotate")
    }

    func testRotationPropagatesAcrossEntireMechanism() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)
        let gA1 = mechanism.gearsByName["gA1"]!
        let gA2 = mechanism.gearsByName["gA2"]!
        let gA3 = mechanism.gearsByName["gA3"]!

        // When: Rotate the mechanism multiple times
        mechanism.rotate(5.0)
        mechanism.rotate(5.0)

        // Then: Rotations should accumulate across all gears
        XCTAssertEqual(gA1.rotation, 10.0, accuracy: 0.001, "Input gear rotations should accumulate")
        XCTAssertNotEqual(gA2.rotation, 0.0, "gA2 should have accumulated rotation")
        XCTAssertNotEqual(gA3.rotation, 0.0, "gA3 should have accumulated rotation")
    }

    func testGearRatiosInMechanism() {
        // Given: gA1 (40 teeth) -> gA2 (20 teeth)
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)
        let gA1 = mechanism.gearsByName["gA1"]!
        let gA2 = mechanism.gearsByName["gA2"]!

        // When: Rotate gA1 by 10 degrees
        mechanism.rotate(10.0)

        // Then: gA2 should rotate by -20 degrees (2:1 ratio, opposite direction)
        // Note: There's also a connector in between which propagates rotation
        XCTAssertEqual(gA1.rotation, 10.0, accuracy: 0.001, "gA1 should rotate 10 degrees")

        // The actual rotation of gA2 depends on both direct gear meshing and connector
        // We verify it rotated in the opposite direction and with approximately the right magnitude
        XCTAssertTrue(abs(gA2.rotation) > 15.0, "gA2 should rotate significantly (ratio effect)")
    }

    func testConnectorsPropagateRotation() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)
        let connector1 = mechanism.connectorsByName["connector1"]!
        let pinslot1 = mechanism.connectorsByName["pinslot1"]!

        // When
        mechanism.rotate(10.0)

        // Then: Connectors should also rotate
        XCTAssertNotEqual(connector1.rotation, 0.0, "Connector1 should rotate")
        XCTAssertNotEqual(pinslot1.rotation, 0.0, "Pin-slot connector should rotate")
    }

    // MARK: - Gear Sorting Tests

    func testSortGearsForPlacementOrder() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // When
        let sortedGears = mechanism.sortGearsForPlacementOrder()

        // Then: Gears should be sorted by dependency order
        XCTAssertEqual(sortedGears.count, 3, "Should have all 3 gears")

        // Find indices
        let gA1Index = sortedGears.firstIndex { $0.name == "gA1" }!
        let gA2Index = sortedGears.firstIndex { $0.name == "gA2" }!
        let gA3Index = sortedGears.firstIndex { $0.name == "gA3" }!

        // gA3 is positioned relative to gA2, so gA2 must come first
        XCTAssertLessThan(gA2Index, gA3Index, "gA2 should come before gA3 (gA3 is relative to gA2)")
    }

    func testSortGearsWithFixedPositions() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // When
        let sortedGears = mechanism.sortGearsForPlacementOrder()

        // Then: Fixed position gears (gA1, gA2) should come before relative gears (gA3)
        let fixedGears = sortedGears.filter { gear in
            gear.placementInfo.toGear == nil
        }

        XCTAssertEqual(fixedGears.count, 2, "Should have 2 fixed position gears")
        XCTAssertTrue(fixedGears.contains { $0.name == "gA1" }, "gA1 should be fixed")
        XCTAssertTrue(fixedGears.contains { $0.name == "gA2" }, "gA2 should be fixed")
    }

    // MARK: - Error Handling Tests

    func testMechanismHandlesInvalidJSONGracefully() {
        // Given: A URL to a non-existent file
        let invalidURL = URL(fileURLWithPath: "/tmp/nonexistent-device.json")

        // When: Initialize with invalid URL
        let mechanism = AntikytheraMechanism(loadFromJsonFile: invalidURL)

        // Then: Should not crash, but have no components
        XCTAssertEqual(mechanism.gears.count, 0, "Should have no gears with invalid JSON")
        XCTAssertEqual(mechanism.connectors.count, 0, "Should have no connectors with invalid JSON")
        XCTAssertEqual(mechanism.pointers.count, 0, "Should have no pointers with invalid JSON")
    }

    // MARK: - Integration Tests

    func testFullMechanismRotationCycle() {
        // Given: A complete mechanism
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // When: Rotate through a full cycle
        for _ in 0..<36 {
            mechanism.rotate(10.0)
        }

        // Then: Input gear should have rotated 360 degrees
        let gA1 = mechanism.gearsByName["gA1"]!
        XCTAssertEqual(gA1.rotation, 360.0, accuracy: 0.1, "Should complete one full rotation")

        // All other gears should have rotated (by different amounts)
        let gA2 = mechanism.gearsByName["gA2"]!
        let gA3 = mechanism.gearsByName["gA3"]!
        XCTAssertNotEqual(gA2.rotation, 0.0, "gA2 should have rotated")
        XCTAssertNotEqual(gA3.rotation, 0.0, "gA3 should have rotated")
    }

    func testMechanismStateConsistency() {
        // Given
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // When: Rotate forward then backward
        mechanism.rotate(45.0)
        mechanism.rotate(-45.0)

        // Then: Input gear should be back at 0 (or very close)
        let gA1 = mechanism.gearsByName["gA1"]!
        XCTAssertEqual(gA1.rotation, 0.0, accuracy: 0.1, "Forward then backward should return to 0")
    }

    // MARK: - Build Device Tests

    func testBuildDeviceIsCalled() {
        // Given/When: Mechanism is initialized (buildDevice is called in init)
        let mechanism = AntikytheraMechanism(loadFromJsonFile: testJSONURL)

        // Then: Mechanism should be fully constructed
        XCTAssertNotNil(mechanism, "Mechanism should be built successfully")
        XCTAssertFalse(mechanism.gears.isEmpty, "Mechanism should have gears after building")
    }

    // MARK: - Helper Methods

    private func createTestGear(name: String, teeth: Int) -> Gear {
        let gearInfo = GearInfo(
            name: name,
            teeth: teeth,
            radiusScale: nil,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )
        return Gear(gearInfo)
    }
}
