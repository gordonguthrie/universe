%%%-------------------------------------------------------------------
%% @doc universe top level supervisor.
%%
%% This is always empty - universe does nothing except start other
%% applications
%%
%% @end
%%%-------------------------------------------------------------------

-module(universe_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

% # Public OTP API

% This is a normal Erlang OTP application.

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

% when you build your own app you will develop your own specialist
% servers or even supervisor/server subsystem trees and you will
% start them all from here

init([]) ->
    SupFlags  = #{strategy => one_for_all,
                  intensity => 0,
                  period => 1},
    Router     = {belka_router, {belka_router, start_link, []},
                  permanent, 5000, worker, [belka_router]},
    Templates  = {belka_templates, {belka_templates, start_link, []},
                  permanent, 5000, worker, [belka_templates]},
    ChildSpecs = [
                    Router,
                    Templates
                 ],
    {ok, {SupFlags, ChildSpecs}}.

% # There are no internal functions.