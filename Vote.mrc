*********************NEW VOTING SYSTEM BEGIN*******************************
on 1:TEXT:!vote*:#: {
  if (%vlimit. [ $+ [ $address($nick,2) ] ] == 2) { halt }
  inc -u36000 %vlimit. [ $+ [ $address($nick,2) ] ] 1 
  if (%vote.used. [ $+ [ $address($nick,2) ] ] == 1) { halt }
  if ($3 == $me) { 
    if (%voteused. [ $+ [ $address($nick,2) ] ] >= 120) { 
      set -u3600 %vanick. [ $+ [ $nick ] ] $nick
      msg $chan Don't do that %vanick $+ ! %voteused. [ $+ [ $address($nick,2) ] ] seconds Silence
      cs devoice %chan %vanick. [ $+ [ $nick ] ]
      timervar. [ $+ [ %vanick ] ] 1 %voteused. [ $+ [ $address($nick,2) ] ] cs voice %vanick. [ $+ [ $nick ] ]
      halt
    }
    set -u3600 %vanick $nick
    inc -u3600 %voteused. [ $+ [ $address($nick,2) ] ] 60
    msg $chan Don't do that $nick $+ ! %voteused. [ $+ [ $address($nick,2) ] ] seconds Silence
    cs devoice %chan %vanick
    timerva. [ $+ [ %vanick ] ] 1 60 cs voice %chan %vanick
    halt
  }
  if (!$2) || (!$3) {
    set -u5 %vote.used. [ $+ [ $address($nick,2) ] ] 1
    notice $nick Syntax: !vote <kick/mute/ban> nickname
    halt
  }
  if ($2 == mute) || ($2 == ban) || ($2 == kick) { }
  else {
    set -u5 %vote.used. [ $+ [ $address($nick,2) ] ] 1
    notice $nick You need to use mute or kick or ban Only!
    halt
  }
  if ($3 ison %chan) { }
  else {
    set -u5 %vote.used. [ $+ [ $address($nick,2) ] ] 1
    notice $nick $3 is not in $chan
    halt
  }
  if (%voteon2 == off) { }
  elseif (%voteon2 == on) {
    notice $nick Syntax: !yes or !no
    halt
  }
  set -u120 %vote.used. [ $+ [ $address($nick,2) ] ] 1
  set %votednick $nick
  set %voteon2 on
  set %votetype $2
  set %votename $3
  callvote
}
alias -l callvote {
  if (%votetype == kick) {
    votekick
    halt
  }
  if (%votetype == ban) {
    voteban
    halt
  }
  if (%votetype == mute) {
    votemute
    halt
  }
}

alias -l votekick {
  set %chanvote $chan
  msg $chan $nick has called a vote to kick %votename $+ . You have 60 seconds to vote. (!yes/!no)
  notice $nick Vote active: Kick %votename ?
  .timer 1 60 v.kick
}

alias -l voteban {
  set %chanvote $chan
  msg $chan $nick has called a vote to ban %votename $+ . You have 60 seconds to vote. (!yes/!no)
  notice $nick Vote active: Ban %votename ?
  set -u65 %bannee $address(%votename,2)
  .timer 1 60 v.ban
}

alias -l votemute {
  set %chanvote $chan
  msg $chan $nick has called a vote to mute %votename $+ . You have 30 seconds to vote.(!yes/!no)
  notice $nick Vote active: Mute %votename ?
  .timer 1 30 v.mute
}

alias -l v.kick {
  if (%voteon2 == off) {
    set %voteon2 0
    set %vyes 0
    set %vno 0
    unset %voted
    halt 
  }
  if (%vyes > %vno) {
    set %rck $r(1,3)
    if (%vno == 0) && (%vyes == %rck) { msg %chan %votename Unfair Vote against You revenge is sweet | kick %chanvote %votednick Reverse Judgement Granted! Your Democratic right has been exercised, shuush now! | goto contk }
    if (%rck == $calc(%vyes - %rck)) { msg %chan %votename The Angels of #Chillroom are with You! | goto contk }
    kick %chanvote %votename Judgement Granted! Democracy exercised, shuush now!
  }
  else {
    msg %chan %votename Simply Put: They failed! is this Democracy or Anarchy? :p
  }
  :contk
  timer 1 2 msg %chan %votename Results: $iif(%vyes == 1,%vyes person voted Yes,%vyes people voted Yes) : $iif(%vno == 1,%vno person voted No,%vno people voted No)
  set %voteon2 off
  set %vyes 0
  set %vno 0
  unset %voted
}

alias -l v.ban {
  if (%voteon2 == off) {
    set %voteon2 0
    set %vyes 0
    set %vno 0
    unset %voted
  }
  if (%vyes > %vno) {
    set %rcb $r(1,3)
    if (%vno == 0) && (%vyes == %rcb) { msg %chan %votename Unfair Vote against You revenge is sweet | cs ban %chan +60 %votednick Reverse Judgement Granted!(Sit tight for 60 seconds) | goto contb }
    if (%rcb == $calc(%vyes - %rcb)) { msg %chan %votename The Angels of #Chillroom are with You! | goto contb }
    inc -u86400 %bancount. [ $+ [ $address(%votename,2) ] ] 600
    if (%bancount. [ $+ [ $address(%votename,2) ] ] > 600) { cs ban %chan + $+ %bancount. [ $+ [ $address(%votename,2) ] ] %bannee Judgement Granted!, shuush now! Incremental Ban: (Sit tight for %bancount. [ $+ [ $address(%votename,2) ] ] seconds) | goto contb }
    cs ban %chan +600 %bannee Judgment Granted! Your Democratic right has been exercised, shuush now! (Sit tight for 600 seconds)
  }
  else {
    msg %chan %votename Simply Put: They failed! is this Democracy or Anarchy? :p
  }
  :contb
  timer 1 2 msg %chan %votename Results: $iif(%vyes == 1,%vyes person voted Yes,%vyes people voted Yes) : $iif(%vno == 1,%vno person voted No,%vno people voted No)
  set %voteon2 off
  set %vyes 0
  set %vno 0
  unset %voted
}

alias -l v.mute {
  if (%voteon2 == off) {
    set %voteon2 0
    set %vyes 0
    set %vno 0
    unset %voted
  }
  if (%vyes > %vno) {
    set %rcm $r(1,3) 
    if (%vno == 0) && (%vyes == %rcm) { msg %chan %votename Unfair Vote against You revenge is sweet | cs devoice %chan %votednick | .timer $+ %votednick 1 60 cs voice %chan %votednick | goto contm }
    if (%rcm == $calc(%vyes - %rcm)) { msg %chan %votename The Angels of #Chillroom are with You! | goto contm }
    inc -u86400 %mutecount. [ $+ [ %votename ] ] 120
    if (%mutecount. [ $+ [ %votename ] ] >= 240) { msg %chan %votename muted for %mutecount. [ $+ [ %votename ] ] seconds [120 second increments] | cs devoice %chan %votename | timermute $+ %votename 1 %mutecount. [ $+ [ %votename ] ] cs voice %chan %votename | guser devoice %votename | .timerdevoice. $+ %votename 1 %mutecount. [ $+ [ %votename ] ] ruser devoice $nick $+ ! | goto contm }
    msg %chan %votename muted for %mutecount. [ $+ [ %votename ] ] seconds [120 second increments]
    cs devoice %chan %votename
    timer $+ %votename 1 120 cs voice %chan %votename
    guser devoice %votename
    timerdevoice. $+ %votename 1 120 ruser devoice $nick $+ !
  }
  else {
    msg %chan %votename Simply Put: They failed! is this Democracy or Anarchy?
  }
  :contm
  timer 1 2 msg %chan %votename Results: $iif(%vyes == 1,%vyes person voted Yes,%vyes people voted Yes) : $iif(%vno == 1,%vno person voted No,%vno people voted No)
  set %voteon2 off
  set %vyes 0
  set %vno 0
  unset %voted
}

on 1:TEXT:!yes*:*: {
  if (%voteon2 == off) {
    if (%yes.ask.y [ $+ [ $address($nick,2) ] ] == 1) { halt }
    set -u2 %yes.ask.y [ $+ [ $address($nick,2) ] ] 1
    notice $nick There is nothing to vote for.
    halt
  }
  if ($istok(%voted,$address,32)) {
    if (%ask.checky [ $+ [ $nick ] ] == 1) { halt }
    set -u2 %ask.checky [ $+ [ $nick ] ] 1
    notice $nick You have already voted.
    halt
  }
  notice $nick You Voted: Yes
  inc %vyes 1
  %voted = $addtok(%voted,$address,32)
}

on 1:TEXT:!no*:*: {
  if (%voteon2 == off) {
    if (%no.ask.n [ $+ [ $address($nick,2) ] ] == 1) { halt }
    set -u2 %no.ask.n [ $+ [ $address($nick,2) ] ] 1
    notice $nick There is nothing to vote for.
    halt
  }
  if ($istok(%voted,$address,32)) {
    if (%ask.checkn [ $+ [ $nick ] ] == 1) { halt }
    set -u2 %ask.checkn [ $+ [ $nick ] ] 1
    notice $nick You have already voted.
    halt
  }
  notice $nick You Voted: No
  inc %vno 1
  %voted = $addtok(%voted,$address,32)
}
;****************************END*******************************************************
