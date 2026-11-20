"use strict";
(async function(){
 const root=document.getElementById('event-list');
 const errorBox=document.getElementById('event-error');
 function el(tag,text){const n=document.createElement(tag);n.textContent=text;return n;}
 root.textContent='Učitavanje događaja…';
 try {
  const base=String(window.SUPABASE_URL||'').trim().replace(/\/+$/,'');
  const key=String(window.SUPABASE_PUBLISHABLE_KEY||'').trim();
  if(!base||!key||base.includes('PASTE_')||key.includes('PASTE_'))throw new Error('Nedostaje Project URL ili Publishable key u supabase-config.js.');
  const url=new URL(base);
  if(url.pathname!=='/'&&url.pathname!=='')throw new Error('Project URL mora biti osnovni URL bez /rest/v1 ili /auth/v1.');
  const endpoint=base+'/rest/v1/events?select=*&order=event_date.asc,event_time.asc';
  const response=await fetch(endpoint,{headers:{apikey:key,Accept:'application/json'},cache:'no-store',signal:AbortSignal.timeout(20000)});
  const body=await response.text();let data;
  try{data=JSON.parse(body);}catch{throw new Error('Poslužitelj nije vratio JSON (HTTP '+response.status+').');}
  if(!response.ok)throw new Error('HTTP '+response.status+': '+(data.message||data.error||body));
  if(!Array.isArray(data))throw new Error('Neočekivan oblik podataka iz tablice events.');
  root.replaceChildren();
  if(!data.length){root.append(el('p','Trenutačno nema javno dostupnih događaja.'));return;}
  for(const event of data){
   const card=el('article','');card.className='card event';
   const stamp=el('time','');stamp.className='date';
   const date=new Date(event.event_date+'T12:00:00');
   stamp.textContent=date.toLocaleDateString('hr-HR',{weekday:'long',day:'numeric',month:'long',year:'numeric'})+' · '+String(event.event_time).slice(0,5);
   stamp.dateTime=event.event_date+'T'+String(event.event_time);
   const description=el('p',event.description||'');description.style.whiteSpace='pre-line';
   card.append(stamp,el('h2',event.title),description,el('p','Lokacija: '+event.location));
   if(event.contact){const mail=el('a',event.contact);mail.href='mailto:'+encodeURIComponent(event.contact)+'?subject='+encodeURIComponent(event.title);card.append(mail);}
   root.append(card);
  }
 }catch(error){
  root.replaceChildren();errorBox.hidden=false;
  const message=error.name==='TimeoutError'?'Veza sa Supabaseom nije odgovorila unutar 20 sekundi.':error.message;
  errorBox.textContent='Događaji se nisu mogli učitati. '+message;
  console.error('Učitavanje javnih događaja:',error);
 }
})();
