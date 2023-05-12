# rbx-util

## [compose](https://wally.run/package/rasmusmerzin/compose?version=1.0.0)

```luau
function compose(
    className: string,
    properties: Table<string, any>?,
    children: { Instance }?
): Instance
```

## [Maid](https://wally.run/package/rasmusmerzin/maid?version=1.0.0)

```luau
type Maid = {
    new: Function<Maid>,
    Add: Function<Variant, (Maid, Variant)>,
    Append: Function<{ Variant }, (Maid, { Variant })>,
    Destroy: Function<void, Maid>
}
```

## [StackQueue](https://wally.run/package/rasmusmerzin/stackqueue?version=1.0.0)

```luau
type StackQueue = {
    new: Function<StackQueue>,
    Append: Function<void, StackQueue>,
}
```

## [Repository](https://wally.run/package/rasmusmerzin/repository?version=0.1.0)

DataStore wrapper utility.

```luau
type Repository = {
    new: Function<Repository, Init>,
    Get: Function<Repository.Entity, number | string | Player>,
    Entity.Start: Function<void, (Repository.Entity, Player)>
}
```

## [Message](https://wally.run/package/rasmusmerzin/message?version=0.2.0)

Bundle of services for sending messages to clients.

- AnnouncementService
  - :Announce
  - :AnnounceFor
- CountdownService
  - :Countdown
- DialogueService
  - :DialogueFor
- HitmarkerService
  - :HitmarkerFor
- LoadingService
  - :SetLoading
  - :SetLoadingFor
- LogService
  - :LogAll
  - :LogTo
