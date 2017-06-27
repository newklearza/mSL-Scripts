;NB: NB NB NB by newklear! This a channel * text match with the example format: on *:TEXT:*:#ChillRoom: { }
on 1:TEXT:*:%chan:{
  if ($nick == LadyMorticia) { halt }
  inc -u5 %fl. [ $+ [ $address($nick,2) ] ]
  if (%fl. [ $+ [ $address($nick,2) ] ] >= 10) {
    if (%fl.length. [ $+ [ $address($nick,2) ] ] >= 300) { cs ban %chan +3600 $address($nick,2) ¯\_(ツ)_/¯ | msg $chan 60 Minute Ban for $nick $+ . ¯\_(ツ)_/¯  | notice nick 60 Minute Ban for you $nick $+ . ¯\_(ツ)_/¯ | halt }
    inc -u600 %fl.length. [ $+ [ $address($nick,2) ] ] 60
    if (%fl.length. [ $+ [ $address($nick,2) ] ] == 180) { mode $chan -v $nick | .timerv. $+ $nick 1 %fl.length. [ $+ [ $address($nick,2) ] ] mode $chan +v $nick | msg $chan You are Silenced for %fl.length. [ $+ [ $address($nick,2) ] ] seconds due to your Flooding Repeats $nick $+ . This is your Final warning $+ , Ban of 10 minute ban comes next. | set -u3600 %fl.bt. [ $+ [ $address($nick,2) ] ] 600 | guser devoice $nick | timerflooddevoice. $+ $nick 1 %fl.length. [ $+ [ $address($nick,2) ] ] ruser devoice $nick $+ ! | halt }
    if (%fl.length. [ $+ [ $address($nick,2) ] ] >= 240) { mode $chan -v $nick | .timervo. $+ $nick 1 %fl.length. [ $+ [ $address($nick,2) ] ] mode $chan +v $nick | cs ban %chan + $+ %fl.bt. [ $+ [ $address($nick,2) ] ] $address($nick,2) ¯\_(ツ)_/¯ | msg $chan $calc(%fl.bt. [ $+ [ $address($nick,2) ] ] / 60) Minute Ban for you $nick $+ . 🐐 | inc -u3600 %fl.bt. [ $+ [ $address($nick,2) ] ] 600 | guser devoice $nick | timerflooddevoice. $+ $nick 1 %fl.length. [ $+ [ $address($nick,2) ] ] ruser devoice $nick $+ ! | halt }
    mode $chan -v $nick
    .timerv. $+ $nick 1 %fl.length. [ $+ [ $address($nick,2) ] ] mode $chan +v $nick
    msg $chan Excessive Flooding by $nick $+ , silenced for %fl.length. [ $+ [ $address($nick,2) ] ] seconds.
    guser devoice $nick 
    timerflooddevoice. $+ $nick 1 %fl.length. [ $+ [ $address($nick,2) ] ] ruser devoice $nick $+ !
  }
  checknum
  randchill
  randMod
  randAdmin
  var %swears = $ud,!cunt,ass licker,bastards,bible,bitch,b itch,bitches,bitches?,buttcrack,butthurt,christ,christs,circle jerk,clit,cock,Cocakoalabalaam,cock blocker,crack,cross dressing,cunt,cunts,C.UNTS,Damnbusiness,dick,dicks,dick head,double adapter,drag queen,#dumbFuck,dum shit,dumbshit,dumsh1t,dumshit,evilmonkeychokesondicks,fk,F(*(**&K !!!,F*(*&*(*&(K!!!,F*K,f.ag,ftsk,faaaked,faggotness,flirt,#flirt,fuckkkkkkkkkkk,fuc.k,f.uuck,fuckµ,f00k,fag,fcuk,fkd,fkn,fk,fook,fok,fu,fuck,Fuck!!!!!!,fucked,fucken,fucker,fuckers,fuckin,fucking,fuk,fukin,gash,gay fucker,gfy,heavenly,Heavenly|work,heavenly?,heavenly's,ho,hoe,hotnot,Iantjie,islamic,islamic.,jews,jesus,jesus christ,k.affer,ka.f.fer,ka.ffer,kaffir,kaffirs,kafur,kcuf,kill,klonkie,kullid,Louwtjie,mike hoxbig,moffie,moffy,mother fucker,motherfucker,naai,naaier,naaid,noisewater,OfYourDamnbusiness,p.e.n.i.s,p.oes,PENISSSSSSSSSSSSSSSSSS!,p3nis,pe.nis,pee pe,pee pee,peenis,pen.is,pen0rs,penis,penor,po.es,poes,poess,poesss,POESSSSS,pooce,poos,prick,puck,puss,pussy,PUSSSSSSSSSYYYYYYYY,PUSSSSSSSYYYYY,pussies,rooinek,rubyy,rubyy?,Rubyy??,rukus,#soSad,SH IT,shit head,shithead,slut,sniffcock,stfu,straight,toe,thundercunt,twat,vagina,vok,voetsek,white,pig,whitey,whore,whores,whorin,x-dressing 
  var %warns = 3
  var %x = $numtok(%swears,44)
  tokenize 32 $strip($1-)
  while (%x) {
    if ($istok($1-,$gettok(%swears,%x,44),32)) {
      inc -u300 $+(%,swear.,$wildsite)
      var %n = $($+(%,swear.,$wildsite),2)
      if (%n == %warns) {
        inc -u21600 %swer.time. [ $+ [ $address($nick,2) ] ] 120
        notice $nick $nick $+ , $ord(%n) instance of innapropriate language within the last 6 hours. $iif(%n = %warns,Last Warning or %swer.time. [ $+ [ $address($nick,2) ] ] second Incremental Silence coming your way.)
      }
      elseif (%n > %warns) {
        if ($nick == JohnCreed) { halt }
        if ($nick == evilmonkey) { halt }
        if ($nick == farmerjoe) { halt }
        if ($nick == Bastard) { halt }
        mode $chan -v $nick 
        timerrev. $+ $nick 1 %swer.time. [ $+ [ $address($nick,2) ] ] cs voice %chan $nick
        msg $chan $nick has been silenced %swer.time. [ $+ [ $address($nick,2) ] ] seconds for bad language.
        guser devoice $nick
        timerdevoice. $+ $address($nick,2) 1 %swer.time. [ $+ [ $address($nick,2) ] ] ruser devoice $nick $+ !
        unset $+(%,swear.,$wildsite)
        ;*****check above this line for mistakes or put the line back to: unset $+(%,swear.,$wildsite)
      }
    }
    dec %x
  }
}
;********************END*******************************************************
