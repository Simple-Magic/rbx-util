"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[671],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>f});var r=n(67294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var c=r.createContext({}),s=function(e){var t=r.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(c.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,c=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=s(n),m=a,f=p["".concat(c,".").concat(m)]||p[m]||d[m]||o;return n?r.createElement(f,i(i({ref:t},u),{},{components:n})):r.createElement(f,i({ref:t},u))}));function f(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,i=new Array(o);i[0]=m;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l[p]="string"==typeof e?e:a,i[1]=l;for(var s=2;s<o;s++)i[s]=n[s];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},59881:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>c,contentTitle:()=>i,default:()=>d,frontMatter:()=>o,metadata:()=>l,toc:()=>s});var r=n(87462),a=(n(67294),n(3905));const o={sidebar_position:1},i="Getting Started",l={unversionedId:"intro",id:"intro",title:"Getting Started",description:"These Roblox utility modules can be acquired using Wally, a package manager for Roblox.",source:"@site/docs/intro.md",sourceDirName:".",slug:"/intro",permalink:"/rbx-util/docs/intro",draft:!1,editUrl:"https://github.com/Simple-Magic/rbx-util/edit/main/docs/intro.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"defaultSidebar"},c={},s=[{value:"Wally Configuration",id:"wally-configuration",level:2},{value:"Rojo Configuration",id:"rojo-configuration",level:2},{value:"Usage Example",id:"usage-example",level:2}],u={toc:s},p="wrapper";function d(e){let{components:t,...n}=e;return(0,a.kt)(p,(0,r.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"getting-started"},"Getting Started"),(0,a.kt)("p",null,"These Roblox utility modules can be acquired using ",(0,a.kt)("a",{parentName:"p",href:"https://wally.run/"},"Wally"),", a package manager for Roblox."),(0,a.kt)("h2",{id:"wally-configuration"},"Wally Configuration"),(0,a.kt)("p",null,"Once Wally is installed, run ",(0,a.kt)("inlineCode",{parentName:"p"},"wally init")," on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a ",(0,a.kt)("inlineCode",{parentName:"p"},"wally.toml")," file for a project that includes a few of these modules:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-toml"},'[package]\nname = "your_name/your_project"\nversion = "0.1.0"\nregistry = "https://github.com/UpliftGames/wally-index"\nrealm = "shared"\n\n[dependencies]\nMaid = "rasmusmerzin/maid@1"\nRepository = "rasmusmerzin/repository@1"\nStackQueue = "rasmusmerzin/stackqueue@1"\ncompose = "rasmusmerzin/compose@1"\n')),(0,a.kt)("p",null,"To install these dependencies, run ",(0,a.kt)("inlineCode",{parentName:"p"},"wally install")," within your project. Wally will create a Package folder in your directory with the installed dependencies."),(0,a.kt)("h2",{id:"rojo-configuration"},"Rojo Configuration"),(0,a.kt)("p",null,"The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-json"},'{\n  "name": "rbx-util-example",\n  "tree": {\n    "$className": "DataModel",\n    "ReplicatedStorage": {\n      "$className": "ReplicatedStorage",\n      "Packages": {\n        "$path": "Packages"\n      }\n    }\n  }\n}\n')),(0,a.kt)("h2",{id:"usage-example"},"Usage Example"),(0,a.kt)("p",null,"The installed dependencies can now be used in scripts, such as the following:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'-- Reference folder with packages:\nlocal Packages = game:GetService("ReplicatedStorage").Packages\n\n-- Require the utility modules:\nlocal Repository = require(Packages.Repository)\n\n-- Use the modules:\nlocal ProfileRepository = Repository.new({ Name = "Profiles" })\n\nfunction ProfileRepository.Entity:Start(player: Player?)\n    if player then self.DisplayName = player.DisplayName end\nend\n')))}d.isMDXComponent=!0}}]);