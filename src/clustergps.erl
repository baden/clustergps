%% Copyright (c) 2014-..., Denis Batrak <denis@batrak.net>

-module(clustergps).

% For erl -s clustergps
-export([start/0]).

% Application here
-behavior(application).
-export([start/2, stop/1]).

% Supervisor is also here
-behavior(supervisor).
-export([init/1]).

start() ->
    application:ensure_all_started(?MODULE).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Application callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(_, _) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, root).

stop(_) ->
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Supervisor callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(root) ->
    {ok, _} = start_cowboy(),
    Counter = {counter, {clustergps_counter, start_link, []},
                permanent, 1000, worker, [clustergps_counter]},
    {ok, {{one_for_one, 10, 5}, [Counter]}}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Internals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_cowboy() ->
    UserInc = {"/inc/:amount", clustergps_handler, user_inc},
    DefPath = {'_', clustergps_handler, []},        % Catch-all path
    Host = {'_', [UserInc, DefPath]},                        % No virtualhosts
    Dispatch = cowboy_router:compile([Host]),
    Env = [{env, [{dispatch, Dispatch}]}],
    Hooks = configured_hooks(),
    cowboy:start_http(?MODULE, 10, [{port, conf(port, 2080)}], Env ++ Hooks).

conf(Key, Default) ->
    application:get_env(?MODULE, Key, Default).

configured_hooks() ->
    case conf(log_access, true) of
        true -> [{onresponse, fun clustergps_log:access_log_hook/4}];
        false -> []
    end.
