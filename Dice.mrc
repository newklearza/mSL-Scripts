on *:TEXT:!ds*:#: {
  if (%dicestats. [ $+ [ $address($nick,2) ] ] >= 5) { halt }
  if (%dicestats. [ $+ [ $address($nick,2) ] ] == 3) { notice $nick You have one more !ds use within a 5 minute period }
  inc -u300 %dicestats. [ $+ [ $address($nick,2) ] ] 1
  if (!$2) {
    if ($readini($mircdir $+ $chan $+ .ini,DiceRolls, $nick)) {
      var %dicerolls $readini($mircdir $+ $chan $+ .ini,DiceRolls, $nick)
      var %dicewins $readini($mircdir $+ $chan $+ .ini,DiceWins, $nick)
      var %diceave $round($calc(%dicewins / %dicerolls * 100),2)
      .msg $chan $nick $+ 's Win Average is: %diceave $+ % with $iif(!%dicewins,0,%dicewins) wins out of %dicerolls dice rolls.
      halt
    }
    else { .msg $chan No Dice Roll record for you $nick $+ , type !dice | halt }
  }
  if ($readini($mircdir $+ $chan $+ .ini,DiceRolls, $2)) {
    var %dicerolls $readini($mircdir $+ $chan $+ .ini,DiceRolls, $2)
    var %dicewins $readini($mircdir $+ $chan $+ .ini,DiceWins, $2)
    var %diceave $round($calc(%dicewins / %dicerolls * 100),2)
    .msg $chan $2 $+ 's Win Average is: %diceave $+ % with $iif(!%dicewins,0,%dicewins) wins out of %dicerolls dice rolls.
  }
  else { .msg $chan No Dice Roll record for $2 $+ , $nick maybe ask $2 to use !dice ? }
}

on *:TEXT:!dice*:#: {
  if (%dice. [ $+ [ $address($nick,2) ] ] == 1) { .msg $chan $nick I am still waiting for your Arch Enemy too roll | inc -u30 %dice. [ $+ [ $address($nick,2) ] ] 1 | halt }
  if ($2 >= 1000) { msg $chan $nick keep it under 1000 | halt }
  if (%floodd. [ $+ [ $address($nick,2) ] ] >= 3) { halt }
  if (%floodd. [ $+ [ $address($nick,2) ] ] == 2) { .notice $nick You have one more !dice roll within a 10 minute period }
  if (%firstroll == yes) { goto secondroll }
  set -u30 %dice. [ $+ [ $address($nick,2) ] ] 1
  inc -u600 %floodd. [ $+ [ $address($nick,2) ] ] 1
  set -u30 %firstroll yes
  set -u30 %1st.nick $nick
  set -u30 %1stroll.1st.nick $iif($2,$r(1,$2),$r(1,6))
  set -u30 %2ndroll.1st.nick $iif($2,$r(1,$2),$r(1,6))
  set -u30 %1st.nick.result $calc(%1stroll.1st.nick + %2ndroll.1st.nick)
  .msg $chan %1st.nick rolls a %1stroll.1st.nick + %2ndroll.1st.nick == %1st.nick.result
  .timerroll 1 1 msg $chan Who is up to challenge %1st.nick $+ 's Dice roll of %1st.nick.result ? You have 30 seconds!
  .timerdiceend 1 30 msg $chan No one wanted too challenge $nick :/
  .timerrollend1 1 30 unset %firstroll | .timerrollend2 1 30 unset %dice*
  halt
  :secondroll
  set -u30 %2nd.nick $nick
  set -u30 %1stroll.2nd.nick $iif($2,$r(1,$2),$r(1,6))
  set -u30 %2ndroll.2nd.nick $iif($2,$r(1,$2),$r(1,6))
  set -u30 %2nd.nick.result $calc(%1stroll.2nd.nick + %2ndroll.2nd.nick)
  .msg $chan %2nd.nick rolls a %1stroll.2nd.nick + %2ndroll.2nd.nick == %2nd.nick.result

  if (%1st.nick.result == %2nd.nick.result) { 
    set %dicerolls1 $readini($mircdir $+ $chan $+ .ini,DiceRolls, %1st.nick)
    set %dicerolls2 $readini($mircdir $+ $chan $+ .ini,DiceRolls, %2nd.nick)
    if (%dicerolls1 >= 1) && (%dicerolls2 >= 1) {
      inc %dicerolls1 1
      inc %dicerolls2 1
      writeini -n $mircdir $+ $chan $+ .ini DiceRolls %1st.nick %dicerolls1
      .msg $chan It is a DRAW!, try again ;) 
      writeini -n $mircdir $+ $chan $+ .ini DiceRolls %2nd.nick %dicerolls2
      goto finishroll 
    }
  }
  .timerrolll 1 1 msg $chan $iif(%1st.nick.result > %2nd.nick.result,%1st.nick wins with %1st.nick.result against %2nd.nick.result,%2nd.nick wins with %2nd.nick.result against %1st.nick.result)
  if (%1st.nick.result > %2nd.nick.result) {
    set %dicerolls1 $readini($mircdir $+ $chan $+ .ini,DiceRolls, %1st.nick)
    if (%dicerolls1 >= 1) {
      set %dicewins $readini($mircdir $+ $chan $+ .ini,DiceWins, %1st.nick)
      set %dicerolls2 $readini($mircdir $+ $chan $+ .ini,DiceRolls, %2nd.nick)
      inc %dicewins 1
      inc %dicerolls1 1
      inc %dicerolls2 1
      writeini -n $mircdir $+ $chan $+ .ini DiceWins %1st.nick %dicewins
      writeini -n $mircdir $+ $chan $+ .ini DiceRolls %1st.nick %dicerolls1
      writeini -n $mircdir $+ $chan $+ .ini DiceRolls %2nd.nick %dicerolls2
      goto finishroll
    }
    writeini -n $mircdir $+ $chan $+ .ini DiceWins %1st.nick 1
    writeini -n $mircdir $+ $chan $+ .ini DiceRolls %1st.nick 1
    writeini -n $mircdir $+ $chan $+ .ini DiceRolls %2nd.nick 1
    goto finishroll
  }
  if (%2nd.nick.result > %1st.nick.result) {
    set %dicerolls1 $readini($mircdir $+ $chan $+ .ini,DiceRolls, %2nd.nick)
    if (%dicerolls1 >= 1) {
      set %dicewins $readini($mircdir $+ $chan $+ .ini,DiceWins, %2nd.nick)
      set %dicerolls2 $readini($mircdir $+ $chan $+ .ini,DiceRolls, %1st.nick)
      inc %dicewins 1
      inc %dicerolls1 1
      inc %dicerolls2 1
      writeini -n $mircdir $+ $chan $+ .ini DiceWins %2nd.nick %dicewins
      writeini -n $mircdir $+ $chan $+ .ini DiceRolls %2nd.nick %dicerolls1
      writeini -n $mircdir $+ $chan $+ .ini DiceRolls %1st.nick %dicerolls2
      goto finishroll
    }
    writeini -n $mircdir $+ $chan $+ .ini DiceWins %2nd.nick 1
    writeini -n $mircdir $+ $chan $+ .ini DiceRolls %2nd.nick 1
    writeini -n $mircdir $+ $chan $+ .ini DiceRolls %1st.nick 1
    goto finishroll
  }
  :finishroll
  .msg $chan Dice roll challenge has ended!
  .timerdiceend off
  unset %firstroll
  unset %dice*
}
