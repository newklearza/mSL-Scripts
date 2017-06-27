on 1:TOPIC:%chan: { 
  set -u10 %rtopicnumber $r(1,10)
  set %randtopic $r(600,21600) 
  if (%rtopicnumber == 1) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan I heard $nick($chan,$rand(1,$nick($chan,0))) bragging about https://www.youtube.com/watch?v=zLdeKpq8Sm0 on Paul_Ely's 101 about rule 7 - enjoy the little thigs!
  }
  if (%rtopicnumber == 2) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan $nick($chan,$rand(1,$nick($chan,0))) Wants to be princess for the day!
  }
  if (%rtopicnumber == 3) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan $nick($chan,$rand(1,$nick($chan,0))) Definitely has the hots for $nick($chan,$rand(1,$nick($chan,0)))
  }
  if (%rtopicnumber == 4) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan Hello and Welcome to #ChillRoom did you Vote or Just stare at the pictures on: www.chillroomirc.co.za/mass or are you staring at $nick($chan,$rand(1,$nick($chan,0)))
  }
  if (%rtopicnumber == 5) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan $nick($chan,$rand(1,$nick($chan,0))) is the ONE!
  }
  if (%rtopicnumber == 6) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan Join us on Telegram when away from IRC: https://t.me/joinchat/AAAAAAyn_JskJx7IHMHgxA
  }
  if (%rtopicnumber == 7) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan $nick($chan,$rand(1,$nick($chan,0))) Was last seen Chilling with $nick($chan,$rand(1,$nick($chan,0)))
  }
  if (%rtopicnumber == 8) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan Welcome to #ChillRoom, you can choose either the red or ble pill. So $nick($chan,$rand(1,$nick($chan,0))) !
  }
  if (%rtopicnumber == 9) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan Why did you say that about $nick($chan,$rand(1,$nick($chan,0))) , $nick($chan,$rand(1,$nick($chan,0))) ?
  }
  if (%rtopicnumber == 10) { 
    timertopicm 1 %randtopic msg %chan [Auto Topic Change:] 
    timertopic 1 %randtopic topic %chan This Topic Needs To Be Changed: !Topic new topic
  }
}

on 1:TEXT:!topic*:%chan: { 
  if (!$2) { notice $nick Syntax: !topic your channel topic | halt }
  if (%topic. [ $+ [ $address($nick,2) ] ] == 1) { halt }
  set -u60 %topic. [ $+ [ $address($nick,2) ] ] 1
  if (!$2) { notice $nick Syntax: !topic your channel topic }
  topic %chan $2-
}

on 1:TEXT:.topic*:?: { 
  if (!$2) { msg $nick Syntax: .topic your channel topic | halt }
  if (%topic. [ $+ [ $address($nick,2) ] ] == 1) { halt }
  set -u60 %topic. [ $+ [ $address($nick,2) ] ] 1
  if (!$2) { msg $nick Syntax: !topic your channel topic }
  topic %chan $2-
}
