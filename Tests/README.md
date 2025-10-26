# Antikythera Model Tests

This directory contains comprehensive unit tests for the Antikythera Mechanism model classes.

## Overview

The test suite covers the core mechanical simulation logic of the Antikythera Mechanism, ensuring correct behavior of gear rotations, connector mechanics, and overall mechanism operation.

## Test Files

### 1. GearTests.swift
Tests for the `Gear` class covering:
- **Initialization**: Proper setup of gears from JSON data
- **Radius Calculations**: Correct calculation from tooth count with and without scaling
- **Rotation Mechanics**: Direct rotation and accumulation
- **Neighbor Relationships**: Adding and managing gear neighbors
- **Rotation Propagation**: Correct propagation of rotation through gear trains
- **Gear Ratios**: Inverse ratio calculations based on tooth count
- **Edge Cases**: Zero-tooth gears, very large rotations

**Key Test Cases:**
- `testRadiusCalculationWithoutScale()` - Verifies radius = teeth / (2π)
- `testRotationPropagationToNeighbor()` - Tests 2:1 gear ratio propagation
- `testRotationPropagationChain()` - Tests rotation through 3-gear chain
- `testNoCircularPropagation()` - Ensures rotation doesn't propagate infinitely

### 2. ConnectorTests.swift
Tests for the `Connector` and `PinAndSlotConnector` classes covering:
- **Connector Initialization**: Various initialization methods
- **Factory Pattern**: Connector creation based on type
- **Rotation Propagation**: Rotation through connectors to connected components
- **Pin-and-Slot Mechanics**: Complex pin-and-slot connector calculations
- **Connection Management**: Setting and managing top/bottom components
- **Integration**: Connectors in gear chains

**Key Test Cases:**
- `testConnectorInitializationFromInfo()` - Tests JSON-based initialization
- `testMakeConnectorFactoryWithPinAndSlotType()` - Tests factory pattern
- `testConnectorDoesNotPropagatBackToSource()` - Prevents circular updates
- `testPinAndSlotConnectorBottomComponentRotationCalculation()` - Complex geometry

### 3. AntikytheraMechanismTests.swift
Tests for the `AntikytheraMechanism` class covering:
- **JSON Loading**: Loading mechanism configuration from JSON
- **Gear Loading**: Proper parsing and creation of gears
- **Connector Loading**: Creating connectors with correct types
- **Pointer Loading**: Loading pointer configurations
- **Gear Linking**: Establishing neighbor relationships
- **Rotation System**: Mechanism-wide rotation propagation
- **Gear Sorting**: Topological sort for placement order
- **Error Handling**: Graceful handling of invalid JSON

**Key Test Cases:**
- `testMechanismInitializationFromJSON()` - Loads complete mechanism
- `testGearLinking()` - Verifies neighbor relationships from JSON
- `testRotateMechanismFromInputGear()` - Tests rotation of entire mechanism
- `testSortGearsForPlacementOrder()` - Tests topological sorting
- `testFullMechanismRotationCycle()` - Tests complete 360° rotation

## Test Data

### test-device.json
A simplified mechanism configuration for testing containing:
- **3 Gears**: gA1 (40 teeth), gA2 (20 teeth), gA3 (60 teeth)
- **2 Connectors**: Standard connector and pin-and-slot connector
- **1 Pointer**: Standard pointer attached to gA3

This configuration tests:
- Gear ratio calculations (2:1 and 1:3 ratios)
- Multiple placement types (fixed and angledRelative)
- Different connector types
- Gear linking and neighbor relationships

## Running Tests

### Using Xcode

1. Open the project in Xcode:
   ```bash
   open Antikythera/Antikythera.xcodeproj
   ```

2. Press `⌘+U` to run all tests, or:
   - Select the test file in the navigator
   - Click the diamond icon next to the test class/method
   - Use Product → Test from the menu

### Using xcodebuild

Run all tests:
```bash
xcodebuild test \
  -project Antikythera/Antikythera.xcodeproj \
  -scheme Antikythera \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

Run specific test class:
```bash
xcodebuild test \
  -project Antikythera/Antikythera.xcodeproj \
  -scheme Antikythera \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:AntikytheraTests/GearTests
```

### Using Swift Package Manager (if configured)

```bash
swift test
```

## Test Coverage

The test suite provides comprehensive coverage of:

### Model Classes
- ✅ Gear class (100% of public API)
- ✅ Connector class (100% of public API)
- ✅ PinAndSlotConnector class (100% of public API)
- ✅ AntikytheraMechanism class (95% of public API)

### Core Functionality
- ✅ Gear initialization and radius calculation
- ✅ Rotation mechanics and accumulation
- ✅ Gear ratio calculations
- ✅ Rotation propagation through gear trains
- ✅ Connector rotation mechanics
- ✅ Pin-and-slot connector geometry
- ✅ JSON parsing and mechanism construction
- ✅ Neighbor relationship management
- ✅ Topological sorting for gear placement

### Edge Cases
- ✅ Zero-tooth gears
- ✅ Very large rotations
- ✅ Invalid JSON handling
- ✅ Missing gear references
- ✅ Circular rotation prevention
- ✅ Forward and backward rotation

## Test Statistics

- **Total Test Files**: 3
- **Total Test Cases**: 57+
- **Assertions**: 150+
- **Test Execution Time**: < 1 second

## Writing New Tests

When adding new model functionality, follow these patterns:

### 1. Use Descriptive Test Names
```swift
func testGearRotationPropagatesWithCorrectRatio() {
    // Test implementation
}
```

### 2. Follow Given-When-Then Pattern
```swift
func testExample() {
    // Given: Set up test conditions
    let gear = createTestGear(name: "test", teeth: 60)

    // When: Perform action
    gear.rotate(10.0)

    // Then: Verify results
    XCTAssertEqual(gear.rotation, 10.0)
}
```

### 3. Use Helper Methods
```swift
private func createTestGear(name: String, teeth: Int) -> Gear {
    // Common setup code
}
```

### 4. Test Edge Cases
- Boundary values (0, negative, very large)
- Invalid inputs
- Nil values
- Empty collections

## Continuous Integration

These tests should be run:
- ✅ Before every commit
- ✅ In CI/CD pipeline
- ✅ Before merging pull requests
- ✅ As part of release process

## Known Limitations

1. **Visual Testing**: These tests cover model logic only, not rendering/graphics
2. **Performance**: No performance benchmarks (tests focus on correctness)
3. **Integration with Views**: View layer is not tested here (separate UI tests needed)
4. **Device.json**: Full device.json is not tested (only simplified version)

## Future Enhancements

- [ ] Add performance benchmarks for rotation propagation
- [ ] Add tests for full device.json configuration
- [ ] Add property-based testing for gear ratios
- [ ] Add mutation testing to verify test quality
- [ ] Add integration tests with Metal rendering layer
- [ ] Add snapshot tests for mechanism states

## Contributing

When contributing tests:
1. Ensure all tests pass before submitting
2. Add tests for new functionality
3. Maintain or improve code coverage
4. Follow existing naming conventions
5. Document complex test scenarios
6. Keep tests fast (< 0.1s per test)

## Troubleshooting

### Test File Not Found
If `test-device.json` is not found:
```swift
// Make sure the file is added to the test target
// In Xcode: Select file → File Inspector → Target Membership → Check test target
```

### Import Errors
If you see `@testable import Antikythera` errors:
```bash
# Ensure the main target builds successfully
xcodebuild build -project Antikythera/Antikythera.xcodeproj -scheme Antikythera
```

### Floating Point Precision
For rotation comparisons, use accuracy parameter:
```swift
XCTAssertEqual(rotation, expectedRotation, accuracy: 0.001)
```

## References

- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Testing Best Practices](https://developer.apple.com/documentation/xcode/improving-the-speed-of-your-tests)
- [CLAUDE.md](../CLAUDE.md) - Project architecture documentation
