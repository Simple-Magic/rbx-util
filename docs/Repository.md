# Repository

DataStore wrapper utility.

```luau
type Repository = {
    new: Function<Repository, Init>,
    Get: Function<Repository.Entity, (Repository, number | string | Player)>,
    Entity.Start: Function<void, (Repository.Entity, Player)>
}
```
