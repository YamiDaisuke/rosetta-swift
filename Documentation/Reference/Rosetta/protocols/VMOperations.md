**PROTOCOL**

# `VMOperations`

```swift
public protocol VMOperations
```

## Properties
### `null`

```swift
var null: VMBaseType
```

Gets the empty value representation for the implementing language

## Methods
### `binaryOperation(lhs:rhs:operation:)`

```swift
func binaryOperation(lhs: VMBaseType?, rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType
```

Maps and applies binary operation on the implementing language
- Parameters:
  - lhs: The left hand operand
  - rhs: The right hand operand
- Throws: A language specific error if the values or the operator is not recognized
- Returns: The result of the operation depending on the operands

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The left hand operand |
| rhs | The right hand operand |

### `unaryOperation(rhs:operation:)`

```swift
func unaryOperation(rhs: VMBaseType?, operation: OpCodes) throws -> VMBaseType
```

Maps and applies unary operation on the implementing language
- Parameters:
  - rhs: The right hand operand
- Throws: A language specific error if the values or the operator is not recognized
- Returns: The result of the operation depending on the operand

#### Parameters

| Name | Description |
| ---- | ----------- |
| rhs | The right hand operand |

### `getLangBool(for:)`

```swift
func getLangBool(for bool: Bool) -> VMBaseType
```

Gets the language specific representation of a VM boolean value

We could simple use native `Bool` from swift but in this way we keep all
the values independent of the swift language.
- Parameter bool: The swift `Bool` value to wrap
- Returns: A representation of swift `Bool` in the implementing language

#### Parameters

| Name | Description |
| ---- | ----------- |
| bool | The swift `Bool` value to wrap |

### `isTruthy(_:)`

```swift
func isTruthy(_ value: VMBaseType?) -> Bool
```

Check if a value of the implemeting language is considered an equivalent of `true`
- Parameter value: The value to check
- Returns: `true` if the given value is considered truthy in the implementing language

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value to check |

### `buildLangArray(from:)`

```swift
func buildLangArray(from array: [VMBaseType]) -> VMBaseType
```

Takes a native Swift array of the lang base type and converts it to the lang equivalent
- Parameter array: An swift Array

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift Array |

### `buildLangHash(from:)`

```swift
func buildLangHash(from array: [AnyHashable: VMBaseType]) -> VMBaseType
```

Takes a native Swift dictionary of the lang base type as both key and value, and converts it to the lang equivalent
- Parameter array: An swift dictionary

#### Parameters

| Name | Description |
| ---- | ----------- |
| array | An swift dictionary |

### `executeIndexExpression(_:index:)`

```swift
func executeIndexExpression(_ lhs: VMBaseType, index: VMBaseType) throws -> VMBaseType
```

Performs an language index (A.K.A subscript) operation in the form of: `<expression>[<expression>]`
- Parameters:
  - lhs: The value to be indexed
  - index: The index to apply

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | The value to be indexed |
| index | The index to apply |

### `decodeFunction(_:)`

```swift
func decodeFunction(_ function: VMBaseType) -> VMFunctionDefinition?
```

Extract the VM instructions and locals count from a language especific compiled function
- Parameter function: The supposed function
- Returns: A value conforming the `VMFunctionDefinition` protocol or `nil`
           if `function` is not actually a compiled function representation

#### Parameters

| Name | Description |
| ---- | ----------- |
| function | The supposed function |

### `getBuiltinFunction(_:)`

```swift
func getBuiltinFunction(_ index: Int) -> VMBaseType?
```

Gets a language specific builtin function
- Parameter index: The function index generated by the compiler
- Returns: An object representing the requested function

#### Parameters

| Name | Description |
| ---- | ----------- |
| index | The function index generated by the compiler |

### `executeBuiltinFunction(_:args:)`

```swift
func executeBuiltinFunction(_ function: VMBaseType, args: [VMBaseType]) throws -> VMBaseType?
```

Should execute a builtin function
- Parameter function: The function to execute
- Returns: The produced value or nil if `function` is not a valid BuiltIn function

#### Parameters

| Name | Description |
| ---- | ----------- |
| function | The function to execute |