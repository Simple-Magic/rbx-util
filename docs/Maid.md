# Maid

```luau
type Maid = {
    new: Function<Maid>,
    Add: Function<Variant, (Maid, Variant)>,
    Append: Function<{ Variant }, (Maid, { Variant })>,
    Destroy: Function<void, Maid>
}
```
