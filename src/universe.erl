% # This is the universe - it calls in belka apps as dependencies and starts them

-module(universe).

% This is a normal Erlang OTP application - it exposes the callbacks
% which are defined in the `application` behaviour.

-behaviour(application).

% ## Public API

% Nothing unusual the normal application API

-export([start/2, stop/1]).

% The `start` function starts the secure socket layer (`ssl`) which Gemini needs

% We define the port using the default `gemini://` port number og `1965`
% (the year of the Mercury mission fact fans).

% In theory this port is conventional - you could change it, but some `gemini://` clients
% don't accept URLs with non-default port numbers in, so YMMV

% `start` also picks up certificates and keys which define this server. `gemini://`
% conventional uses both self-signed keys and self-signed certificates and
% a new set for your server can be generated with the batch file `generate_self_signed_certs.sh`

% in the default example we are generating keys for the domain 'localhost' in production you would have a different name.

% In addition belka supports multiple hosts on the same server - so you can pass a list of site/certificate pairs in.

% ***Remember:*** you gotta edit that batch file with your org name, the URL you are
% serving `gemini://` no and your contact details and stuff

% All applications start a top level supervisor and we do so here. When you read the source code you will see that that supervisor is not starting any children in this example.

start(_StartType, _StartArgs) ->
    ok = ssl:start(),
    Port = 1965,
    CertFile1 = "./priv/sites/localhost/keys/server.crt",
    KeyFile1  = "./priv/sites/localhost/keys/server.key",
    CertFile2 = "./priv/sites/chess.local/keys/server.crt",
    KeyFile2  = "./priv/sites/chess.local/keys/server.key",
    Cert1 = #{certfile => CertFile1,
              keyfile  => KeyFile1},
    Cert2 = #{certfile => CertFile2,
              keyfile  => KeyFile2},
    Certs = [{"localhost", Cert1}, {"chess.local", Cert2}],
    _PID = belka:start(Port, Certs, {belka_router, dispatch}),
    universe_sup:start_link().

stop(_State) ->
    ok.

% There are no private functions