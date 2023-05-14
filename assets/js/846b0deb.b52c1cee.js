"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[709],{3905:(e,t,r)=>{r.d(t,{Zo:()=>u,kt:()=>m});var n=r(67294);function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function a(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?o(Object(r),!0).forEach((function(t){i(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,n,i=function(e,t){if(null==e)return{};var r,n,i={},o=Object.keys(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||(i[r]=e[r]);return i}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(i[r]=e[r])}return i}var s=n.createContext({}),c=function(e){var t=n.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):a(a({},t),e)),r},u=function(e){var t=c(e.components);return n.createElement(s.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},g=n.forwardRef((function(e,t){var r=e.components,i=e.mdxType,o=e.originalType,s=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=c(r),g=i,m=p["".concat(s,".").concat(g)]||p[g]||d[g]||o;return r?n.createElement(m,a(a({ref:t},u),{},{components:r})):n.createElement(m,a({ref:t},u))}));function m(e,t){var r=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var o=r.length,a=new Array(o);a[0]=g;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l[p]="string"==typeof e?e:i,a[1]=l;for(var c=2;c<o;c++)a[c]=r[c];return n.createElement.apply(null,a)}return n.createElement.apply(null,r)}g.displayName="MDXCreateElement"},78404:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>s,contentTitle:()=>a,default:()=>d,frontMatter:()=>o,metadata:()=>l,toc:()=>c});var n=r(87462),i=(r(67294),r(3905));const o={},a="Message",l={unversionedId:"Message",id:"Message",title:"Message",description:"Bundle of services for sending messages to clients.",source:"@site/docs/Message.md",sourceDirName:".",slug:"/Message",permalink:"/rbx-util/docs/Message",draft:!1,editUrl:"https://github.com/Simple-Magic/rbx-util/edit/main/docs/Message.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"Maid",permalink:"/rbx-util/docs/Maid"},next:{title:"PlayerList",permalink:"/rbx-util/docs/PlayerList"}},s={},c=[{value:"AnnouncementService",id:"announcementservice",level:2},{value:"CountdownService",id:"countdownservice",level:2},{value:"DialogueService",id:"dialogueservice",level:2},{value:"HitmarkerService",id:"hitmarkerservice",level:2},{value:"LoadingService",id:"loadingservice",level:2},{value:"LogService",id:"logservice",level:2}],u={toc:c},p="wrapper";function d(e){let{components:t,...r}=e;return(0,i.kt)(p,(0,n.Z)({},u,r,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"message"},"Message"),(0,i.kt)("p",null,"Bundle of services for sending messages to clients."),(0,i.kt)("h2",{id:"announcementservice"},"AnnouncementService"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},":Announce(message: string, options: AnnouncementOptions?)"),(0,i.kt)("li",{parentName:"ul"},":AnnounceFor(player: Player, message: string, options: AnnouncementOptions?)")),(0,i.kt)("h2",{id:"countdownservice"},"CountdownService"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},":Countdown(count: Integer)")),(0,i.kt)("h2",{id:"dialogueservice"},"DialogueService"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},":DialogueFor(player: Player, options: DialogueOptions?): Signal")),(0,i.kt)("h2",{id:"hitmarkerservice"},"HitmarkerService"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},":HitmarkerFor(player: Player, content: string)")),(0,i.kt)("h2",{id:"loadingservice"},"LoadingService"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},":SetLoading(loading: boolean)"),(0,i.kt)("li",{parentName:"ul"},":SetLoadingFor(player: Player, loading: boolean)")),(0,i.kt)("h2",{id:"logservice"},"LogService"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},":LogAll(message: string)"),(0,i.kt)("li",{parentName:"ul"},":LogTo(player: Player, message: string)")))}d.isMDXComponent=!0}}]);