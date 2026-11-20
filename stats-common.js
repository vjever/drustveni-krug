"use strict";
window.DK={
 el(tag,text,cls){const n=document.createElement(tag);if(text!==undefined)n.textContent=text;if(cls)n.className=cls;return n;},
 async request(table,params){const base=String(window.SUPABASE_URL||'').trim().replace(/\/+$/,'');const key=String(window.SUPABASE_PUBLISHABLE_KEY||'').trim();if(!base||!key||base.includes('PASTE_')||key.includes('PASTE_'))throw Error('Dopuni supabase-config.js.');let output=[],offset=0;while(true){const r=await fetch(base+'/rest/v1/'+table+'?'+new URLSearchParams({...params,limit:500,offset}),{headers:{apikey:key,Accept:'application/json'},cache:'no-store',signal:AbortSignal.timeout(20000)});const d=await r.json();if(!r.ok)throw Error(d.message||'HTTP '+r.status);if(!Array.isArray(d))throw Error('Neočekivan odgovor baze.');output.push(...d);if(d.length===0)break;offset+=d.length;}return output;},
 date(value){return new Date(value+'T12:00:00').toLocaleDateString('hr-HR');},
 table(headers,rows){const div=this.el('div',undefined,'stats-scroll');const t=this.el('table');const head=this.el('thead'),tr=this.el('tr');headers.forEach(x=>tr.append(this.el('th',x)));head.append(tr);t.append(head);const b=this.el('tbody');rows.forEach(row=>{const r=this.el('tr');row.forEach(x=>r.append(this.el('td',String(x))));b.append(r);});t.append(b);div.append(t);return div;}
};
