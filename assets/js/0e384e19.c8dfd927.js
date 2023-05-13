"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[671],{3905:(e,t,n)=>{n.d(t,{Zo:()=>s,kt:()=>y});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function o(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var u=r.createContext({}),p=function(e){var t=r.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},s=function(e){var t=p(e.components);return r.createElement(u.Provider,{value:t},e.children)},c="mdxType",m={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,i=e.originalType,u=e.parentName,s=o(e,["components","mdxType","originalType","parentName"]),c=p(n),d=a,y=c["".concat(u,".").concat(d)]||c[d]||m[d]||i;return n?r.createElement(y,l(l({ref:t},s),{},{components:n})):r.createElement(y,l({ref:t},s))}));function y(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var i=n.length,l=new Array(i);l[0]=d;var o={};for(var u in t)hasOwnProperty.call(t,u)&&(o[u]=t[u]);o.originalType=e,o[c]="string"==typeof e?e:a,l[1]=o;for(var p=2;p<i;p++)l[p]=n[p];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},9881:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>u,contentTitle:()=>l,default:()=>m,frontMatter:()=>i,metadata:()=>o,toc:()=>p});var r=n(7462),a=(n(7294),n(3905));const i={},l="rbx-util",o={unversionedId:"intro",id:"intro",title:"rbx-util",description:"compose",source:"@site/docs/intro.md",sourceDirName:".",slug:"/intro",permalink:"/rbx-util/docs/intro",draft:!1,editUrl:"https://github.com/Simple-Magic/rbx-util/edit/main/docs/intro.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar"},u={},p=[{value:"compose",id:"compose",level:2},{value:"Maid",id:"maid",level:2},{value:"StackQueue",id:"stackqueue",level:2},{value:"Repository",id:"repository",level:2},{value:"Message",id:"message",level:2},{value:"Bar",id:"bar",level:2},{value:"PlayerList",id:"playerlist",level:2},{value:"IsoCamera",id:"isocamera",level:2}],s={toc:p},c="wrapper";function m(e){let{components:t,...n}=e;return(0,a.kt)(c,(0,r.Z)({},s,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"rbx-util"},"rbx-util"),(0,a.kt)("h2",{id:"compose"},(0,a.kt)("a",{parentName:"h2",href:"https://wally.run/package/rasmusmerzin/compose?version=1.0.0"},"compose")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-luau"},"function compose(\n    className: string,\n    properties: Table<string, any>?,\n    children: { Instance }?\n): Instance\n")),(0,a.kt)("h2",{id:"maid"},"Maid"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-luau"},"type Maid = {\n    new: Function<Maid>,\n    Add: Function<Variant, (Maid, Variant)>,\n    Append: Function<{ Variant }, (Maid, { Variant })>,\n    Destroy: Function<void, Maid>\n}\n")),(0,a.kt)("h2",{id:"stackqueue"},"StackQueue"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-luau"},"type StackQueue = {\n    new: Function<StackQueue>,\n    Append: Function<void, StackQueue>,\n}\n")),(0,a.kt)("h2",{id:"repository"},"Repository"),(0,a.kt)("p",null,"DataStore wrapper utility."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-luau"},"type Repository = {\n    new: Function<Repository, Init>,\n    Get: Function<Repository.Entity, (Repository, number | string | Player)>,\n    Entity.Start: Function<void, (Repository.Entity, Player)>\n}\n")),(0,a.kt)("h2",{id:"message"},"Message"),(0,a.kt)("p",null,"Bundle of services for sending messages to clients."),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"AnnouncementService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":Announce(message: string, options: AnnouncementOptions?)"),(0,a.kt)("li",{parentName:"ul"},":AnnounceFor(player: Player, message: string, options: AnnouncementOptions?)"))),(0,a.kt)("li",{parentName:"ul"},"CountdownService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":Countdown(count: Integer)"))),(0,a.kt)("li",{parentName:"ul"},"DialogueService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":DialogueFor(player: Player, options: DialogueOptions?): Signal"))),(0,a.kt)("li",{parentName:"ul"},"HitmarkerService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":HitmarkerFor(player: Player, content: string)"))),(0,a.kt)("li",{parentName:"ul"},"LoadingService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":SetLoading(loading: boolean)"),(0,a.kt)("li",{parentName:"ul"},":SetLoadingFor(player: Player, loading: boolean)"))),(0,a.kt)("li",{parentName:"ul"},"LogService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":LogAll(message: string)"),(0,a.kt)("li",{parentName:"ul"},":LogTo(player: Player, message: string)")))),(0,a.kt)("h2",{id:"bar"},"Bar"),(0,a.kt)("p",null,"Bundle of bar widgets. Includes Health and Clock UI."),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"ClockService",(0,a.kt)("ul",{parentName:"li"},(0,a.kt)("li",{parentName:"ul"},":SetClock(startMillis: number, endMillis: number)")))),(0,a.kt)("h2",{id:"playerlist"},"PlayerList"),(0,a.kt)("p",null,"Player list gui which in addition to players shows bots."),(0,a.kt)("h2",{id:"isocamera"},"IsoCamera"),(0,a.kt)("p",null,"Isometric view camera."))}m.isMDXComponent=!0}}]);