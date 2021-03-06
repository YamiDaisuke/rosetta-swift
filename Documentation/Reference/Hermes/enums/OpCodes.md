**ENUM**

# `OpCodes`

```swift
public enum OpCodes: OpCode
```

The operation codes supported by the VM

## Cases
### `constant`

```swift
case constant
```

Stores a constant value in the cosntants pool

### `pop`

```swift
case pop
```

Pops the value at top of the stack

### `add`

```swift
case add
```

Adds the top two values in the stack

### `sub`

```swift
case sub
```

Subsctract the top two values in the stack

### `mul`

```swift
case mul
```

Multiply the top two values in the stack

### `div`

```swift
case div
```

Divide the top two values in the stack one by the other

### `true`

```swift
case `true`
```

Push `true` into the stack

### `false`

```swift
case `false`
```

Push `false` into the stack

### `equal`

```swift
case equal
```

Performs an equality check

### `notEqual`

```swift
case notEqual
```

Performs an inequality check

### `gt`

```swift
case gt
```

Performs an greater than operation

### `gte`

```swift
case gte
```

Performs an greater than or equal operation

### `minus`

```swift
case minus
```

Performs an unary minus operation, E.G.: `-1, -10`

### `bang`

```swift
case bang
```

Performs a negation operation. E.G: `!true = false`

### `jumpf`

```swift
case jumpf
```

Jumps if the next value in the stack is `false`

### `jump`

```swift
case jump
```

Unconditional jump

### `null`

```swift
case null
```

Push the empty value representation into the stack

### `setGlobal`

```swift
case setGlobal
```

Creates a global bound to a value

### `assignGlobal`

```swift
case assignGlobal
```

Assigns a global bound to a value

### `getGlobal`

```swift
case getGlobal
```

Get the value assigned to a global id

### `setLocal`

```swift
case setLocal
```

Creates a local bound to a value

### `assignLocal`

```swift
case assignLocal
```

Assigns a local bound to a value

### `getLocal`

```swift
case getLocal
```

Get the value assigned to a local id

### `array`

```swift
case array
```

Creates an Array from the first "n" elements in the stack

### `hash`

```swift
case hash
```

Creates a HashMap from the first "n" elements in the stack

### `index`

```swift
case index
```

Performs an index operation (subscript in Swift) E.G.: `<expression>[<expression>]`

### `call`

```swift
case call
```

Calls/Execute a function

### `returnVal`

```swift
case returnVal
```

Returns a value from a function

### `return`

```swift
case `return`
```

Returns an empty value from a function

### `getBuiltin`

```swift
case getBuiltin
```

Gets a builtin function native to the implementing language

### `closure`

```swift
case closure
```

Creates a closure for a function

### `getFree`

```swift
case getFree
```

Get a free variable from the closure

### `currentClosure`

```swift
case currentClosure
```

Push the current closure into the stack
