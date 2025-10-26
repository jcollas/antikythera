//
//  GearTests.swift
//  Antikythera
//
//  Unit tests for the Gear model class
//

import XCTest
@testable import Antikythera

class GearTests: XCTestCase {

    // MARK: - Initialization Tests

    func testGearInitialization() {
        // Given
        let gearInfo = GearInfo(
            name: "testGear",
            teeth: 60,
            radiusScale: nil,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )

        // When
        let gear = Gear(gearInfo)

        // Then
        XCTAssertEqual(gear.name, "testGear", "Gear name should be initialized correctly")
        XCTAssertEqual(gear.toothCount, 60, "Tooth count should be initialized correctly")
        XCTAssertEqual(gear.rotation, 0.0, "Initial rotation should be 0")
        XCTAssertTrue(gear.neighbors.isEmpty, "New gear should have no neighbors")
    }

    func testRadiusCalculationWithoutScale() {
        // Given: A gear with 60 teeth and no radius scale
        let gearInfo = GearInfo(
            name: "testGear",
            teeth: 60,
            radiusScale: nil,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )

        // When
        let gear = Gear(gearInfo)

        // Then: radius = teeth / (2π)
        let expectedRadius = Float(60) / (2.0 * Float.pi)
        XCTAssertEqual(gear.radius, expectedRadius, accuracy: 0.001, "Radius should be calculated as teeth / (2π)")
    }

    func testRadiusCalculationWithScale() {
        // Given: A gear with 60 teeth and a radius scale of 2.0
        let gearInfo = GearInfo(
            name: "testGear",
            teeth: 60,
            radiusScale: 2.0,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )

        // When
        let gear = Gear(gearInfo)

        // Then: radius = (teeth / (2π)) * scale
        let expectedRadius = (Float(60) / (2.0 * Float.pi)) * 2.0
        XCTAssertEqual(gear.radius, expectedRadius, accuracy: 0.001, "Radius should be scaled correctly")
    }

    func testLinkedToInitialization() {
        // Given
        let gearInfo = GearInfo(
            name: "testGear",
            teeth: 60,
            radiusScale: nil,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: ["gear1", "gear2"]
        )

        // When
        let gear = Gear(gearInfo)

        // Then
        XCTAssertEqual(gear.linkedTo.count, 2, "LinkedTo array should contain both linked gears")
        XCTAssertTrue(gear.linkedTo.contains("gear1"), "LinkedTo should contain gear1")
        XCTAssertTrue(gear.linkedTo.contains("gear2"), "LinkedTo should contain gear2")
    }

    // MARK: - Neighbor Tests

    func testAddNeighbor() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)

        // When
        gear1.addNeighbor(gear2)

        // Then
        XCTAssertEqual(gear1.neighbors.count, 1, "Gear should have one neighbor")
        XCTAssertTrue(gear1.neighbors[0] === gear2, "Neighbor should be gear2")
    }

    func testAddMultipleNeighbors() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let gear3 = createTestGear(name: "gear3", teeth: 45)

        // When
        gear1.addNeighbor(gear2)
        gear1.addNeighbor(gear3)

        // Then
        XCTAssertEqual(gear1.neighbors.count, 2, "Gear should have two neighbors")
    }

    // MARK: - Rotation Tests

    func testDirectRotation() {
        // Given
        let gear = createTestGear(name: "testGear", teeth: 60)

        // When
        gear.rotate(45.0)

        // Then
        XCTAssertEqual(gear.rotation, 45.0, accuracy: 0.001, "Gear rotation should be updated")
    }

    func testAccumulatedRotation() {
        // Given
        let gear = createTestGear(name: "testGear", teeth: 60)

        // When
        gear.rotate(45.0)
        gear.rotate(30.0)

        // Then
        XCTAssertEqual(gear.rotation, 75.0, accuracy: 0.001, "Rotations should accumulate")
    }

    func testNegativeRotation() {
        // Given
        let gear = createTestGear(name: "testGear", teeth: 60)

        // When
        gear.rotate(45.0)
        gear.rotate(-15.0)

        // Then
        XCTAssertEqual(gear.rotation, 30.0, accuracy: 0.001, "Negative rotations should work correctly")
    }

    // MARK: - Rotation Propagation Tests

    func testRotationPropagationToNeighbor() {
        // Given: Two gears with 2:1 ratio (60 teeth : 30 teeth)
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        gear1.addNeighbor(gear2)
        gear2.addNeighbor(gear1)

        // When: Rotate gear1 by 10 degrees
        gear1.rotate(10.0)

        // Then: gear2 should rotate by -20 degrees (inverse ratio, opposite direction)
        // ratio = gear1.radius / gear2.radius = 2.0
        // gear2 rotation = -10 * 2.0 = -20
        XCTAssertEqual(gear1.rotation, 10.0, accuracy: 0.001, "Gear1 should rotate 10 degrees")
        XCTAssertEqual(gear2.rotation, -20.0, accuracy: 0.1, "Gear2 should rotate -20 degrees")
    }

    func testRotationPropagationChain() {
        // Given: Three gears in a chain (60:30:60)
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let gear3 = createTestGear(name: "gear3", teeth: 60)

        gear1.addNeighbor(gear2)
        gear2.addNeighbor(gear1)
        gear2.addNeighbor(gear3)
        gear3.addNeighbor(gear2)

        // When: Rotate gear1 by 10 degrees
        gear1.rotate(10.0)

        // Then:
        // gear2 rotates -20 degrees (2:1 ratio, opposite direction)
        // gear3 rotates 10 degrees (1:2 ratio, opposite direction again)
        XCTAssertEqual(gear1.rotation, 10.0, accuracy: 0.001, "Gear1 should rotate 10 degrees")
        XCTAssertEqual(gear2.rotation, -20.0, accuracy: 0.1, "Gear2 should rotate -20 degrees")
        XCTAssertEqual(gear3.rotation, 10.0, accuracy: 0.1, "Gear3 should rotate 10 degrees")
    }

    func testUpdateRotationFromSource() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)

        // When: Update gear2's rotation as if it came from gear1
        gear2.updateRotation(10.0, fromSource: gear1)

        // Then: Should apply inverse ratio: -(10 * (60/30)) = -20
        let expectedRotation = -10.0 * (gear1.radius / gear2.radius)
        XCTAssertEqual(gear2.rotation, expectedRotation, accuracy: 0.1, "Rotation should be scaled by gear ratio")
    }

    func testNoCircularPropagation() {
        // Given: Two gears connected to each other
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 60)
        gear1.addNeighbor(gear2)
        gear2.addNeighbor(gear1)

        // When: Rotate gear1
        gear1.rotate(10.0)

        // Then: gear2 should rotate once (not infinitely)
        // After gear1 rotates gear2, gear2 should not rotate gear1 again
        XCTAssertEqual(gear1.rotation, 10.0, accuracy: 0.001, "Gear1 should maintain its rotation")
        XCTAssertEqual(gear2.rotation, -10.0, accuracy: 0.1, "Gear2 should rotate once")
    }

    // MARK: - Edge Cases

    func testZeroToothGear() {
        // Given: A gear with 0 teeth (edge case)
        let gearInfo = GearInfo(
            name: "zeroGear",
            teeth: 0,
            radiusScale: nil,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )

        // When
        let gear = Gear(gearInfo)

        // Then: radius should be 0
        XCTAssertEqual(gear.radius, 0.0, accuracy: 0.001, "Zero tooth gear should have zero radius")
    }

    func testVeryLargeRotation() {
        // Given
        let gear = createTestGear(name: "testGear", teeth: 60)

        // When: Rotate by a very large angle
        gear.rotate(3600.0) // 10 full rotations

        // Then
        XCTAssertEqual(gear.rotation, 3600.0, accuracy: 0.001, "Large rotations should be handled")
    }

    // MARK: - Helper Methods

    private func createTestGear(name: String, teeth: Int, radiusScale: Float? = nil) -> Gear {
        let gearInfo = GearInfo(
            name: name,
            teeth: teeth,
            radiusScale: radiusScale,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )
        return Gear(gearInfo)
    }
}
