-module(spasvc).

-export([main/1, main/0, start_httpd/1]).

main([]) ->
    start_httpd(8000);
main([Port]) ->
    start_httpd(list_to_integer(Port)).

%% for debug
main() ->
    main([]).

start_httpd(Port) ->
    application:ensure_all_started(cowboy),
    StaticConfig =
        {"/static/[...]", cowboy_static, {dir, "./static", [{mimetypes, cow_mimetypes, all}]}},
    SpaConfig = {"/[...]", spasvc_index, []},
    Dispatch = cowboy_router:compile([{'_', [StaticConfig, SpaConfig]}]),
    io:format("Starting the http server on port ~w...~n", [Port]),
    cowboy:start_clear(spasvc_http, [{port, Port}], #{env => #{dispatch => Dispatch}}),
    loop().

%% escript will stop when `main/1` finished
loop() ->
    receive
        _ ->
            loop()
    end.
