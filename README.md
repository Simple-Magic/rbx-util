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
  - :Announce(message: string, options: AnnouncementOptions?)
  - :AnnounceFor(player: Player, message: string, options: AnnouncementOptions?)
- CountdownService
  - :Countdown(count: Integer)
- DialogueService
  - :DialogueFor(player: Player, options: DialogueOptions?): Signal
- HitmarkerService
  - :HitmarkerFor(player: Player, content: string)
- LoadingService
  - :SetLoading(loading: boolean)
  - :SetLoadingFor(player: Player, loading: boolean)
- LogService
  - :LogAll(message: string)
  - :LogTo(player: Player, message: string)

## [Bar](https://wally.run/package/rasmusmerzin/bar?version=1.0.0)

Bundle of bar widgets. Includes Health and Clock UI.

- ClockService
  - :SetClock(startMillis: number, endMillis: number)

## [PlayerList](https://wally.run/package/rasmusmerzin/playerlist?version=1.0.2)

## [IsoCamera](https://wally.run/package/rasmusmerzin/isocamera?version=1.0.0)
