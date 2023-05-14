"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{3905:(e,t,r)=>{r.d(t,{Zo:()=>m,kt:()=>d});var n=r(67294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function c(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?c(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):c(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},c=Object.keys(e);for(n=0;n<c.length;n++)r=c[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var c=Object.getOwnPropertySymbols(e);for(n=0;n<c.length;n++)r=c[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var s=n.createContext({}),i=function(e){var t=n.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},m=function(e){var t=i(e.components);return n.createElement(s.Provider,{value:t},e.children)},u="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},f=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,c=e.originalType,s=e.parentName,m=l(e,["components","mdxType","originalType","parentName"]),u=i(r),f=a,d=u["".concat(s,".").concat(f)]||u[f]||p[f]||c;return r?n.createElement(d,o(o({ref:t},m),{},{components:r})):n.createElement(d,o({ref:t},m))}));function d(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var c=r.length,o=new Array(c);o[0]=f;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l[u]="string"==typeof e?e:a,o[1]=l;for(var i=2;i<c;i++)o[i]=r[i];return n.createElement.apply(null,o)}return n.createElement.apply(null,r)}f.displayName="MDXCreateElement"},4167:(e,t,r)=>{r.r(t),r.d(t,{HomepageFeatures:()=>b,default:()=>v});var n=r(87462),a=r(67294),c=r(3905);const o={toc:[]},l="wrapper";function s(e){let{components:t,...r}=e;return(0,c.kt)(l,(0,n.Z)({},o,r,{components:t,mdxType:"MDXLayout"}),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-toml"},'[dependencies]\nBar = "rasmusmerzin/bar@1.0.0"\nIsoCamera = "rasmusmerzin/isocamera@1.0.0"\nMaid = "rasmusmerzin/maid@1.0.0"\nMessage = "rasmusmerzin/message@0.2.0"\nPlayerList = "rasmusmerzin/playerlist@1.0.2"\nRepository = "rasmusmerzin/repository@1.0.0"\nStackQueue = "rasmusmerzin/stackqueue@1.0.0"\ncompose = "rasmusmerzin/compose@1.0.0"\n')))}s.isMDXComponent=!0;var i=r(39960),m=r(52263),u=r(34510),p=r(86010);const f={heroBanner:"heroBanner_e1Bh",buttons:"buttons_VwD3",features:"features_WS6B",featureSvg:"featureSvg_tqLR"},d=null;function y(e){let{image:t,title:r,description:n}=e;return a.createElement("div",{className:(0,p.Z)("col col--4")},t&&a.createElement("div",{className:"text--center"},a.createElement("img",{className:f.featureSvg,alt:r,src:t})),a.createElement("div",{className:"text--center padding-horiz--md"},a.createElement("h3",null,r),a.createElement("p",null,n)))}function b(){return d?a.createElement("section",{className:f.features},a.createElement("div",{className:"container"},a.createElement("div",{className:"row"},d.map(((e,t)=>a.createElement(y,(0,n.Z)({key:t},e))))))):null}function g(){const{siteConfig:e}=(0,m.Z)();return a.createElement("header",{className:(0,p.Z)("hero",f.heroBanner)},a.createElement("div",{className:"container"},a.createElement("h1",{className:"hero__title"},e.title),a.createElement("p",{className:"hero__subtitle"},e.tagline),a.createElement("div",{className:f.buttons},a.createElement(i.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function v(){const{siteConfig:e,tagline:t}=(0,m.Z)();return a.createElement(u.Z,{title:e.title,description:t},a.createElement(g,null),a.createElement("main",null,a.createElement(b,null),a.createElement("div",{className:"container"},a.createElement(s,null))))}}}]);