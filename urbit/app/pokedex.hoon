/+  *server, default-agent
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  [%0 pokedex=(map @tas cord)]
--
=|  state-zero
=*  state  -
^-  agent:gall
|_  bol=bowl:gall
+*  this       .
    pokedex-core  +>
    cc         ~(. pokedex-core bol)
    def        ~(. (default-agent this %|) bol)
::
++  on-init
  ^-  (quip card _this)
  =/  launcha  [%launch-action !>([%add %pokedex [[%basic 'Pokédex' '/~pokedex/img/tile.png' '/~pokedex'] %.y]])]
  =/  filea  [%file-server-action !>([%serve-dir /'~pokedex' /app/pokedex %.n %.n])]
  :_  this
  :~  [%pass /srv %agent [our.bol %file-server] %poke filea]
      [%pass /pokedex %agent [our.bol %launch] %poke launcha]
      ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  :_  this
  ?+  mark  (on-poke:def mark vase)
    %noun
      =/  pokemon  !<(@tas vase)
      =/  saved-pokemon  (~(get by pokedex.state) pokemon)
      ?~  saved-pokemon
        [%pass /[pokemon] %arvo %i %request (request pokemon) *outbound-config:iris]~
      ~&  u.saved-pokemon
      [%give %fact [/primary]~ %json !>((pairs:enjs:format ~[[%sprite s+u.saved-pokemon]]))]~
  ==
  ::
  ++  request
    |=  pokemon=@tas
    ^-  request:http
    =/  method  %'GET'
    =/  url     (crip (weld "https://pokeapi.co/api/v2/pokemon/" (trip pokemon)))
    =/  header  ~[['Accept' 'application/json']]
    [method url header ~]
  --
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  |^
  ?:  ?=(%bound +<.sign-arvo)
    [~ this]
  ?:  ?=(%http-response +<.sign-arvo)
    =^  cards  state
      (response client-response.sign-arvo)
    [cards this]
  ?+  wire  (on-arvo:def wire sign-arvo)
    [%bind ~]  `this
  ==
  ::
  ++  response
    |=  res=client-response:iris
    ^-  (quip card _state)
    ::
    ?.  ?=(%finished -.res)  `state
    ?:  (gth 200 status-code.response-header.res)  `state
    =/  data  full-file.res
    ?~  data  `state
    =/  json  (de-json:html q.data.u.data)
    ?~  json  `state
    ?>  ?=(%o -.u.json)
    ::
    =/  name  (~(got by p.u.json) 'name')
    ?~  name  `state
    ?>  ?=(%s -.name)
    ::
    =/  sprites  (~(got by p.u.json) 'sprites')
    ?~  sprites  `state
    ?>  ?=(%o -.sprites)
    =/  sprite  (~(got by p.sprites) 'front_default')
    ?>  ?=(%s -.sprite)
    ~&  p.sprite
    ::
    :_  state(pokedex (~(put by pokedex) p.name p.sprite))
    [%give %fact [/primary]~ %json !>((pairs:enjs:format ~[[%sprite s+p.sprite]]))]~
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?:  ?=([%http-response *] path)
    `this
  ?:  ?=([%primary ~] path)
    `this
  ?.  =(/ path)
    (on-watch:def path)
  [[%give %fact ~ %json !>(*json)]~ this]
::
++  on-agent  on-agent:def
++  on-fail   on-fail:def
++  on-leave  on-leave:def
++  on-load   on-load:def
++  on-peek   on-peek:def
++  on-save   on-save:def
--
