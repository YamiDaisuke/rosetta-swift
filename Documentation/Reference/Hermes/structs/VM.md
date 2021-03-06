**STRUCT**

# `VM`

```swift
public struct VM<Operations: VMOperations>
```

Hermes VM implementation

## Properties
### `constants`

```swift
public internal(set) var constants: [VMBaseType]
```

### `globals`

```swift
public internal(set) var globals: [VMBaseType?]
```

### `stackTop`

```swift
public var stackTop: VMBaseType?
```

Returns the current value sitting a top of the stack if the stack is empty returns `nil`

### `lastPoped`

```swift
public var lastPoped: VMBaseType?
```

## Methods
### `init(_:operations:constants:globals:)`

```swift
public init(
    _ bytcode: BytecodeProgram,
    operations: Operations,
    constants: inout [VMBaseType],
    globals: inout [VMBaseType?]
)
```

Creates a VM instance with an existing constants and global lists
- Parameters:
  - bytcode: The bytecode to run
  - operations: An implementation of `VMOperations` in charge of applying the language
                specific operations for this VM
  - constants: A list of existing constants
  - globals: A list of existing globals

#### Parameters

| Name | Description |
| ---- | ----------- |
| bytcode | The bytecode to run |
| operations | An implementation of `VMOperations` in charge of applying the language specific operations for this VM |
| constants | A list of existing constants |
| globals | A list of existing globals |

### `init(_:operations:)`

```swift
public init(_ bytcode: BytecodeProgram, operations: Operations)
```

Init a new VM with a set of bytecode to run
- Parameters:
  - bytcode: The compiled bytecode
  - operations: An implementation of `VMOperations` in charge of applying the language
                specific operations for this VM

#### Parameters

| Name | Description |
| ---- | ----------- |
| bytcode | The compiled bytecode |
| operations | An implementation of `VMOperations` in charge of applying the language specific operations for this VM |

### `init(_:operations:)`

```swift
public init(_ filePath: URL, operations: Operations) throws
```

### `dump()`

```swift
public func dump() -> String
```

Dumps the VM instructions and constants for debugging porpuses
- Returns: The string representation of bytecode and constants

### `run()`

```swift
public mutating func run() throws
```

Runs the VM against the assigned bytecode
- Throws: `VMError` if anything fails while interpreting the bytecode
