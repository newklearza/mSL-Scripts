on *:LOAD: {
  $iif($exists($mircdir/Lotto),,mkdir $mircdir/Lotto)
}

on $*:TEXT:/!tatamachance|!tata|!lotto|!rematch|!ginger|!powerball|!lottery/:#: {
  if (%lottolen) && ($2 == cancel) {
    timerlotto? off
    unset %lotto*
    msg $chan The Lottery has been cancelled $nick $+ .
    return
  }
  if (%lotto.fl [ $+ [ $address($nick,2) ] ] >= 2) { return }
  if (!%lottolen) { 
    if ($2 > 86400) || ($2 < 60) { msg $chan Choose a number in range of: 60 - 86400 | return }
    $iif(!$2,set %lottolen 600,set %lottolen $2) 
  }
  inc -u $+ [ %lottolen ] %lotto.fl [ $+ [ $address($nick,2) ] ] 1
  if (!%lottodraw) { 
    set %lottochan $chan
    set %lottodraw $ctime
    .timerlottodraw 1 %lottolen lotto
    .timerlottodraw1 1 $calc(%lottolen + 5) unset %lotto*
  }
  if ($istok(%lotto,$nick,32)) {
    msg $chan You are already entered into the lottery $nick $+ .
    .timer2 1 1 msg $chan the Lotto Draw will take place in: $duration($timer(lottodraw).secs)
    return
  }
  msg $chan You are entered into the Lottery $nick $+ .
  .timer1 1 1 msg $chan the Lotto Draw will take place in: $duration($timer(lottodraw).secs)
  %lotto = $addtok(%lotto,$nick,32)
}

alias -l lotto {
  var %rand $r(1,$numtok(%lotto,32))
  set %prevnick %winnick
  set %winnick $gettok(%lotto,%rand,32)
  msg %lottochan The Lottery Winner is: %winnick out of $iif($numtok(%lotto,32) == 1,1 entrant.,$numtok(%lotto,32) entrants.) Congratulations!
  .timerlottodraw2 1 1 msg %lottochan You have won OP'S !!!
  var %file $mircdir\Lotto\Lotto.txt 
  if ($read(%file,s,%winnick)) { var %line $readn | var %lwins $gettok($read(%file,%line),2,32) | write -ds $+ %winnick %file | inc %lwins | write %file %winnick %lwins | msg %winnick You have won the Lotto %lwins times. }
  else { write %file %winnick 1 }
  .timerlottodraw3 1 2 mode %lottochan -o %prevnick
  .timerlottodraw4 1 3 mode %lottochan +o %winnick
}

on *:TEXT:!toplotto*:#:{ 
  if (%toplotto. [ $+ [ $address($nick,2) ] ] == 6) { halt }
  inc -u3600 %toplotto. [ $+ [ $address($nick,2) ] ] 1
  if ($2 > 30) { msg $chan Keep it 30 and below @ $nick | return }
  $iif($2,set -u30 %topwhat $2,set -u30 %topwhat 10)
  toplotto #
}

alias -l toplotto {
  var %file = $mircdir\Lotto\Lotto.txt, %l = %toplotto $+ , %d = $lines(%file), %w = @top10
  window -hn %w
  clear %w
  while %d {
    tokenize 32 $read(%file,nt,%d)
    aline %w 4 $+ $2 $+ :3 $1 $+ 10 
    dec %d
  }
  filter -cuteww 2 32 %w %w
  var %k = 1, %k1
  while %k <= %l  {
    %k1 = $addtok(%k1,$+($chr(32),12,$chr(35),%k,) $iif($line(%w,%k),$v1,),44)
    inc %k
  }
  msg $chan  12Top4 %toplotto 12Lotto Winner High Score's:
  msg $chan %k1 $+ .
}
