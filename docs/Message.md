# Message

Bundle of services for sending messages to clients.

## AnnouncementService

- :Announce(message: string, options: AnnouncementOptions?)
- :AnnounceFor(player: Player, message: string, options: AnnouncementOptions?)

## CountdownService

- :Countdown(count: Integer)

## DialogueService

- :DialogueFor(player: Player, options: DialogueOptions?): Signal

## HitmarkerService

- :HitmarkerFor(player: Player, content: string)

## LoadingService

- :SetLoading(loading: boolean)
- :SetLoadingFor(player: Player, loading: boolean)

## LogService

- :LogAll(message: string)
- :LogTo(player: Player, message: string)
