on *:TEXT:!fatality*:#:{
  if (%flfatal. [ $+ [ $address($nick,2) ] ] >= 4) { halt }
  inc -u3600 %flfatal. [ $+ [ $address($nick,2) ] ] 1
  if (!$2) { notice $nick Syntax: !fatality nickname | halt }
  if ($2 ison #) {
    $iif(!$hget(0),restoreFighters,)
    if (!$hget($2)) { notice $nick $2 Does not have any fight record ;) | halt }
    var %fatal $r(1,2)
    if (%fatal == 1) { 
      var %ap %SA. [ $+ [ $address($2,2) ] ]
      var %perc $r(5,75)
      var %damage $round($calc(%perc * %ap / 100),2)
      var %result $round($calc(%ap - %damage),2)
      msg $chan Fatality Success on $2 and loses %damage attack points at a rate of %perc $+ % and now has %result attack points.
      notice $nick You have a 50% chance and have $calc(3 - %flfatal. [ $+ [ $address($nick,2) ] ] ) $iif($calc(3 - %flfatal. [ $+ [ $address($nick,2) ] ] ) == 1,attempt,attempts) left within an hour.
      hadd $2 lastscore %result
      set %SA. [ $+ [ $address($2,2) ] ] %result
    }
    else { msg $chan Your Fatality attempt on $2 was unsuccessful $nick $+ ! | notice $nick You have a 50% chance and have $calc(3 - %flfatal. [ $+ [ $address($nick,2) ] ] ) $iif($calc(3 - %flfatal. [ $+ [ $address($nick,2) ] ] ) == 1,attempt,attempts) left within an hour. }
  }
  else { msg $chan $2 needs to be on the channel for a fatality ! }
}

on $*:TEXT:/!fight|!mwah|!pacify|!passify|!stab|!slap|!smooch|!heya|!flick|!hello|!hit|!kill|!smack|!peace|!love|!hi|!murder|!revive|!pk|!kiss/:#: {
  if ($nick == Willow) { msg $chan You cannot fight $nick $+ , you are retired | return }
  if (%flfight. [ $+ [ $address($nick,2) ] ] >= 5) { halt }
  notice $nick You have $calc(5 - %flfight. [ $+ [ $address($nick,2) ] ] ) $iif($calc(5 - %flfight. [ $+ [ $address($nick,2) ] ] ) == 1,attempt,attempts) left within a 20 minute period.
  if (%flfight. [ $+ [ $address($nick,2) ] ] == 3) { .notice $nick You have one more !fight use within a 20 minute period. }
  inc -u1200 %flfight. [ $+ [ $address($nick,2) ] ] 1
  if ($2 == $nick) { .notice $nick You cannot attack yourself silly! | halt }
  if ($2 == |--) { .notice $nick You cannot attack the Bot :p | halt }
  if ($2 == $me) { .notice $nick You cannot attack the Bot :p | halt }
  if ($2 == help) { .notice $nick Fight Help Commands are: !fight, !fight stats, !fatality, !fight help | halt }
  if ($2 == stats) {
    $iif(!$hget(0),restoreFighters,)
    if ($3) {
      if (!%SA. [ $+ [ $address($3,2) ] ]) { .notice $nick There are no Attack Records for $3 $+ . | halt }
      .notice $nick $3 $+ 's Strike Attack == %SA. [ $+ [ $address($3,2) ] ]
      $iif($hget($3),notice $nick $3 has Won: $hget($3,win) $+ ; Lost: $hget($3,lose) $+ ; and Drawn: $hget($3,draw) with $hget($3,total) matches. Last battled : $hget($3,lastopp) $duration($calc($ctime - $hget($3,lasttime))) ago with a $round($calc($hget($3,win) / $hget($3,total) * 100),2) $+ % win ratio.,notice $nick There are no fight stats for $3 $+ .)
      dec -u180 %flfight. [ $+ [ $address($nick,2) ] ] 1
    }
    else { .notice $nick Syntax: !fight stats nickname }
    halt
  }
  if ($2) {
    $iif(!$hget(0),restoreFighters,)
    if (!%fightreset) { 
      set -u60 %fightreset on
      timerfightreset 00:00 1 4 unset %SA*
      timerfightreset1 00:00 1 10 msg %chan 4Fight 9Stats 13Have 7been 10Reset4!
      timerfightreset2 00:00 1 1 saveFighters
      timerfightreset3 00:00 1 3 unset %fhs*
      timerfightreset4 00:00 1 5 unset %fightreset
      if (%fhs >= 1) {
        timerfightreset5 00:00 1 1 msg %chan %fhs.nick has Won: $hget(%fhs.nick,win) $+ ; Lost: $hget(%fhs.nick,lose) $+ ; and Drawn: $hget(%fhs.nick,draw) with $hget(%fhs.nick,total) matches. Last battled : $hget(%fhs.nick,lastopp) $duration($calc($ctime - $hget(%fhs.nick,lasttime))) ago with a $round($calc($hget(%fhs.nick,win) / $hget(%fhs.nick,total) * 100),2) $+ % win ratio.
        if ($time < 11:59:59) {
          timerfightmidday1 12:00 1 1 msg %chan The Mid Day Champion, for $day is: %fhs.nick with %fhs Attack Points! 
          timerfightmidday2 12:00 1 2 msg %chan %fhs.nick has Won: $hget(%fhs.nick,win) $+ ; Lost: $hget(%fhs.nick,lose) $+ ; and Drawn: $hget(%fhs.nick,draw) with $hget(%fhs.nick,total) matches. Last battled : $hget(%fhs.nick,lastopp) $duration($calc($ctime - $hget(%fhs.nick,lasttime))) ago with a $round($calc($hget(%fhs.nick,win) / $hget(%fhs.nick,total) * 100),2) $+ % win ratio.
        }
      }
    }
    ;timersavefight 1 600 saveFighters 

    if ($2 ison $chan) {
      var %sa $calc(%SA. [ $+ [ $address($nick,2) ] ] + $r(1,10) / 10)
      var %da $calc(%SA. [ $+ [ $address($2,2) ] ] + $r(1,10) / 10)
      if (!%fhs) { $iif(%sa > %da,set %fhs %sa,set %fhs %da) }
      if (%sa > %fhs) && (%sa > %da) {
        inc -u30 %highad1 1
        set %fhs.prev %fhs
        set %fhs.prevnick %fhs.nick
        set %fhs $v1
        set %fhs.nick $nick
        timerhighscorea 00:00 1 2 msg %chan The Champion for $day was: %fhs.nick with %fhs Attack Points!
        $iif(%highad1 >= 2,,notice $nick New High Score of: %fhs by $nick Beats previous high score of: %fhs.prev held by %fhs.prevnick Diff: $calc(%fhs - %fhs.prev) attack points.)    
      }
      if (%da > %fhs) {
        inc -u600 %highad2 1
        set %fhs.prev %fhs
        set %fhs.prevnick %fhs.nick
        set %fhs $v1
        set %fhs.nick $2
        timerhighscorea 00:00 1 2 msg %chan The Champion for $day was: %fhs.nick with %fhs Attack Points!
        $iif(%highad2 >= 3,,notice $2 New High score of: %fhs by $2 Beats previous high score of: %fhs.prev held by %fhs.prevnick Diff: $calc(%fhs - %fhs.prev) attack points.)
      }
      if (%sa == %da) { 
        .msg $chan the Fight is a 13draw! Your SA: %sa vs $2 $+ 's DA: %da 
        set %SA. [ $+ [ $address($nick,2) ] ] $calc(%SA. [ $+ [ $address($nick,2) ] ] + $r(1,5) / 10)
        set %SA. [ $+ [ $address($2,2) ] ] $calc(%SA. [ $+ [ $address($2,2) ] ] + $r(1,5) / 10)    
        if (!$hget($nick)) { hadd -m $nick total 1 | hadd -m $nick lastopp $2 | hadd -m $nick begintime $ctime | hadd -m $nick win 0 | hadd -m $nick lose 0 | hadd -m $nick draw 1 | hadd -m $nick lastscore %sa | halt }
        if (!$hget($2)) { hadd -m $2 total 1 | hadd -m $2 lastopp $2 | hadd -m $2 begintime $ctime | hadd -m $2 win 0 | hadd -m $2 lose 0 | hadd -m $2 draw 1 | hadd -m $2 lastscore %da | halt }   
        var %draw1 $hget($nick,draw)
        var %totd1 $hget($nick,total)
        var %draw2 $hget($2,draw)
        var %totd2 $hget($2,total)
        hadd $nick draw $calc(%draw1 + 1) 
        hadd $nick total $calc(%totd1 + 1)
        hadd $nick lastscore %sa
        hadd $nick lastopp $2
        hadd $nick lasttime $ctime
        hadd $2 draw $calc(%draw2 + 1) 
        hadd $2 total $calc(%totd2 + 1)
        hadd $2 lastscore %da 
        hadd $2 lastopp $nick
        hadd $2 lasttime $ctime
        ;**************************************Fight - by newklear 2018***************************************
      }
      if (%sa > %da) { 
        .msg $chan $nick You have 9beaten $2 $+ ! Your SA: %sa vs $2 $+ 's DA: %da  
        set %SA. [ $+ [ $address($nick,2) ] ] $calc(%SA. [ $+ [ $address($nick,2) ] ] + $r(1,5) / 10)
        set %SA. [ $+ [ $address($2,2) ] ] $calc(%SA. [ $+ [ $address($2,2) ] ] + $r(1,30) / 10)
        if (!$hget($nick)) { hadd -m $nick total 1 | hadd -m $nick lastopp $2 | hadd -m $nick begintime $ctime | hadd -m $nick win 1 | hadd -m $nick lose 0 | hadd -m $nick draw 0 | hadd -m $nick lastscore %sa | halt }
        if (!$hget($2)) { hadd -m $2 total 1 | hadd -m $2 lastopp $2 | hadd -m $2 begintime $ctime | hadd -m $2 win 1 | hadd -m $2 lose 0 | hadd -m $2 draw 0 | hadd -m $2 lastscore %da | halt }
        var %win1 $hget($nick,win)
        var %tot1 $hget($nick,total)
        var %lose1 $hget($2,lose)
        var %tot2 $hget($2,total)
        hadd $nick win $calc(%win1 + 1)
        hadd $nick total $calc(%tot1 + 1)
        hadd $nick lastscore %sa
        hadd $nick lastopp $2
        hadd $nick lasttime $ctime
        hadd $2 lose $calc(%lose1 + 1) 
        hadd $2 total $calc(%tot2 + 1)
        hadd $2 lastscore %da
        hadd $2 lastopp $nick
        hadd $2 lasttime $ctime
      }
      if (%sa < %da) { 
        .msg $chan $nick You 4lost to $2 $+ ! Your SA: %sa vs $2 $+ 's DA: %da  
        set %SA. [ $+ [ $address($nick,2) ] ] $calc(%SA. [ $+ [ $address($nick,2) ] ] + $r(1,5) / 10)
        set %SA. [ $+ [ $address($2,2) ] ] $calc(%SA. [ $+ [ $address($2,2) ] ] + $r(1,15) / 10)
        if (!$hget($nick)) { hadd -m $nick total 1 | hadd -m $nick lastopp $2 | hadd -m $nick begintime $ctime | hadd -m $nick win 0 | hadd -m $nick lose 1 | hadd -m $nick draw 0 | hadd -m $nick lastscore %sa | halt }
        if (!$hget($2)) { hadd -m $2 total 1 | hadd -m $2 lastopp $2 | hadd -m $2 begintime $ctime | hadd -m $2 win 1 | hadd -m $2 lose 0 | hadd -m $2 draw 0 | hadd -m $2 lastscore %da | halt }
        var %lose2 $hget($nick,lose)
        var %tot3 $hget($nick,total)
        var %win2 $hget($2,win)
        var %tot4 $hget($2,total)
        hadd $nick lose $calc(%lose2 + 1)
        hadd $nick total $calc(%tot3 + 1)
        hadd $nick lastscore %sa
        hadd $nick lastopp $2
        hadd $nick lasttime $ctime
        hadd $2 win $calc(%win2 + 1)
        hadd $2 total $calc(%tot4 + 1)
        hadd $2 lastscore %da
        hadd $2 lastopp $nick
        hadd $2 lasttime $ctime
      }
    }
    else { .notice $nick You can only fight someone in the channel. }
  }
  else { .notice $nick Syntax: !fight nickname or !fight stats nickname }
}

alias saveFighters {
  $iif($hget(0),,halt)
  $iif($exists(Fight\ $+ Fighters.txt),remove -b Fight\ $+ Fighters.txt,mkdir Fight)
  save -rv Fight\ $+ vars.ini 
  var %s $hget(0)
  var %ss 1
  while (%ss <= %s) { 
    write Fight\ $+ Fighters.txt $hget(%ss) 
    hsave -s $hget(%ss) Fight\ $+ $hget(%ss) $+ .hsh
    inc %ss 1
  }
}

alias restoreFighters {
  if ($exists(Fight\ $+ Fighters.txt)) { 
    load -rv Fight\ $+ vars.ini
    var %s $lines(Fight\ $+ Fighters.txt)
    var %ss 1
    while (%ss <= %s) { 
      var %nick $read(Fight\ $+ Fighters.txt, %ss) 
      if (!$hget(%nick)) { .hmake %nick 100 }
      if ($exists(%nick $+ .hsh)) { hload -s $read(Fight\ $+ Fighters.txt, %ss) %nick $+ .hsh }
      inc %ss 1 
    }
  }
}
