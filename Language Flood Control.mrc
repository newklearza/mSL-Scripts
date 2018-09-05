on *:TEXT:*:#:{
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
  var %swears = bad,words,go,here 
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
        mode $chan -v $nick 
        timerrev. $+ $nick 1 %swer.time. [ $+ [ $address($nick,2) ] ] cs voice %chan $nick
        msg $chan $nick has been silenced %swer.time. [ $+ [ $address($nick,2) ] ] seconds for bad language.
        guser devoice $nick
        timerdevoice. $+ $address($nick,2) 1 %swer.time. [ $+ [ $address($nick,2) ] ] ruser devoice $nick $+ !
        unset $+(%,swear.,$wildsite)
      }
    }
    dec %x
  }
}
;********************END*******************************************************
