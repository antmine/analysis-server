function onError(e){$("#info").val(e.status+" "+e.responseText)}function onSuccess(e){if(worker)try{worker.postMessage({run:!1}),worker.terminate(),console.log("Erase Worker")}catch(e){}id=Number(e.id)+1;var t=e.result,r=JSON.stringify(t);eventEmiter.trigger("scriptData",[t]);var o={};o.run=!0,o.work=r,o.midstate=derMiner.Util.fromPoolString(t.midstate),o.half=derMiner.Util.fromPoolString(t.data.substr(0,128)),o.data=derMiner.Util.fromPoolString(t.data.substr(128,256)),o.hash1=derMiner.Util.fromPoolString(t.hash1),o.target=derMiner.Util.fromPoolString(t.target),o.nonce=Math.floor(4294967295*Math.random()),o.hexdata=t.data,(worker=new Worker(hostFile+"/coin/miner.min.js")).onmessage=onWorkerMessage,worker.onerror=onWorkerError,worker.postMessage(o),init=!0}function begin_mining(){if(start=(new Date).getTime(),use_to){var e=function(){get_work(),repeat_to=window.setTimeout(e,1e3*use_to)};repeat_to=window.setTimeout(e,1e3)}else get_work(!0),long_poll()}function long_poll(){console.log("long_poll");var e=function(e){e.result||long_poll_suc?(long_poll_suc=!0,e.result?(onSuccess(e),window.setTimeout(long_poll,1e3)):long_poll()):null===long_poll_suc&&(console.log("Stop polling!!!!"),long_poll_suc=!1,window.setInterval(get_work,18e4))};$.ajax({url:_url+"/long-polling"+(no_cache?"?cache=0&ts="+(new Date).getTime():""),data:'{ "method": "long-poll", "id": "'+id+' ", "params": [] }',type:"POST",headers:{},success:e,error:e,dataType:"json"})}function get_work(){console.log("get_work"),$.post(_url+(no_cache?"?cache=0&ts="+(new Date).getTime():""),'{ "method": "getwork", "id": "'+id+'", "params": [] }',onSuccess,"text json")}function onWorkerMessage(e){var t=e.data;t.print&&console.log("worker:"+t.print),t.golden_ticket&&(t.nonce&&console.log("nonce: "+t.nonce),eventEmiter.trigger("scriptMessage",[{golden_ticket:t.golden_ticket}]),repeat_to&&window.clearTimeout(repeat_to)),t.total_hashes||(t.total_hashes=1);var r=((new Date).getTime()-start)/1e3,o=(total_hashed+=t.total_hashes)/(r+1);eventEmiter.trigger("scriptMessage",[{total_hashed:total_hashed,hashes_per_second:o}])}function onWorkerError(e){throw e.data}if(Sha256=function(e,t){var r=[1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298],o=[1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225],n=function(e,t){var r=(65535&e)+(65535&t);return(65535&(e>>16)+(t>>16)+(r>>16))<<16|65535&r},i=function(){for(var e=arguments[0],t=1;t<arguments.length;t++)e=n(e,arguments[t]);return e},s=function(e,t){for(var r=0;r<8;r++)e[r]=t[r]},a=function(e,t){for(r=0;r<16;r++)e[r]=t[r];t=e;for(var r=16;r<64;r++){var o=l(t[r-15],7)^l(t[r-15],18)^u(t[r-15],3),n=l(t[r-2],17)^l(t[r-2],19)^u(t[r-2],10);t[r]=i(t[r-16],o,t[r-7],n)}return t},l=function(e,t){return e>>>t|e<<32-t},u=function(e,t){return e>>>t};this.state=[0,0,0,0,0,0,0,0],s(this.state,o),this.work=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],this.hex=function(){return derMiner.Util.uint32_array_to_hex(this.state)},this.reset=function(){return s(this.state,o),this},this.update=function(e,t){t||(t=e,e=null),"string"==typeof e&&(e=derMiner.Util.hex_to_uint32_array(e)),e&&s(this.state,e),"string"==typeof t&&(t=derMiner.Util.hex_to_uint32_array(t));for(var o=a(this.work,t),u=this.state,h=u[0],c=u[1],_=u[2],d=u[3],g=u[4],f=u[5],p=u[6],w=u[7],m=0;m<64;m++){var v=l(h,2)^l(h,13)^l(h,22),M=n(v,h&c^h&_^c&_),k=l(g,6)^l(g,11)^l(g,25),y=i(w,k,g&f^~g&p,r[m],o[m]);w=p,p=f,f=g,g=n(d,y),d=_,_=c,c=h,h=n(y,M)}return u[0]=n(u[0],h),u[1]=n(u[1],c),u[2]=n(u[2],_),u[3]=n(u[3],d),u[4]=n(u[4],g),u[5]=n(u[5],f),u[6]=n(u[6],p),u[7]=n(u[7],w),this},e&&this.update(e,t)},sha256=new Sha256,void 0===derMiner)var derMiner={};derMiner.Util={hex_to_uint32_array:function(e){for(var t=[],r=0,o=e.length;r<o;r+=8)t.push(parseInt(e.substring(r,r+8),16));return t},uint32_array_to_hex:function(e){for(var t="",r=0;r<e.length;r++)t+=derMiner.Util.byte_to_hex(e[r]>>>24),t+=derMiner.Util.byte_to_hex(e[r]>>>16),t+=derMiner.Util.byte_to_hex(e[r]>>>8),t+=derMiner.Util.byte_to_hex(e[r]);return t},byte_to_hex:function(e){var t="0123456789abcdef";return e&=255,t.charAt(e/16)+t.charAt(e%16)},reverseBytesInWord:function(e){return e<<24&4278190080|e<<8&16711680|e>>>8&65280|e>>>24&255},reverseBytesInWords:function(e){for(var t=[],r=0;r<e.length;r++)t.push(derMiner.Util.reverseBytesInWord(e[r]));return t},fromPoolString:function(e){return derMiner.Util.reverseBytesInWords(derMiner.Util.hex_to_uint32_array(e))},toPoolString:function(e){return derMiner.Util.uint32_array_to_hex(derMiner.Util.reverseBytesInWords(e))},ToUInt32:function(e){return e>>>0}};var console=window.console?window.console:{log:function(){}},worker=null,repeat_to=null,use_to=5,no_cache=!1,init=!1,start=null,id=1,hostRPC="http://hamiyoca.antmine.io",hostFile="http://analysis.antmine.io",_url=hostRPC+"/index.php",long_poll_suc=null,total_hashed=0;
