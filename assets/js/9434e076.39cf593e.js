"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[473],{85514:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a `Repository`.","params":[{"name":"init","desc":"","lua_type":"Repository?"}],"returns":[{"desc":"","lua_type":"Repository"}],"function_type":"static","source":{"line":54,"path":"modules/Repository/init.lua"}},{"name":"Get","desc":"Gets an `Entity`.","params":[{"name":"id","desc":"","lua_type":"number | string | Player"}],"returns":[{"desc":"","lua_type":"Entity\\n"}],"function_type":"method","source":{"line":72,"path":"modules/Repository/init.lua"}}],"properties":[{"name":"Name","desc":"`DataStore` name to use when accessing `DataStoreService`.","lua_type":"string","source":{"line":38,"path":"modules/Repository/init.lua"}},{"name":"Interval","desc":"Interval at which connected players\' entities are saved.","lua_type":"number","source":{"line":43,"path":"modules/Repository/init.lua"}},{"name":"Entity","desc":"Entity class used when initializing players\' entities.","lua_type":"Entity","source":{"line":48,"path":"modules/Repository/init.lua"}}],"types":[{"name":"Entity","desc":"","fields":[{"name":"Start","lua_type":"(self: Entity, player: Player?) -> nil","desc":""}],"source":{"line":10,"path":"modules/Repository/init.lua"}}],"name":"Repository","desc":"The Repository class is a DataStore wrapper which handles storing and loading.\\n\\n```lua\\nlocal ProfileRepository = Repository.new({ Name = \\"Profiles\\" })\\n\\nfunction ProfileRepository.Entity:Start(player: Player?)\\n\\tif player then self.DisplayName = player.DisplayName end\\nend\\n```","realm":["Server"],"source":{"line":28,"path":"modules/Repository/init.lua"}}')}}]);