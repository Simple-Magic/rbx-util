# rbx-util

## compose

```luau
function compose(
    className: string,
    properties: Table<string, any>?,
    children: { Instance }?
): Instance
```

## Maid

```luau
type Maid = {
    new: Function<Maid>,
    Add: Function<Variant, (Maid, Variant)>,
    Append: Function<{ Variant }, (Maid, { Variant })>,
    Destroy: Function<void, Maid>
}
```

## StackQueue

```luau
type StackQueue = {
    new: Function<StackQueue>,
    Append: Function<void, StackQueue>,
}
```

## Repository

DataStore wrapper utility.

```luau
type Repository = {
    new: Function<Repository, Init>,
    Get: Function<Repository.Entity, (Repository, number | string | Player)>,
    Entity.Start: Function<void, (Repository.Entity, Player)>
}
```

## Message

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

## Bar

Bundle of bar widgets. Includes Health and Clock UI.

- ClockService
  - :SetClock(startMillis: number, endMillis: number)

## PlayerList

Player list gui which in addition to players shows bots.

## IsoCamera

Isometric view camera.
