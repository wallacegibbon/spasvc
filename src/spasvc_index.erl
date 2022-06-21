-module(spasvc_index).
-export([init/2, terminate/3]).

init(Req, State) ->
    RespContent = case filelib:is_file("./index.html") of
                      true ->
                          {ok, Content} = file:read_file("./index.html"),
                          Content;
                      false ->
                          <<"index.html is not found">>
                  end,
    Req1 = cowboy_req:reply(200, #{}, RespContent, Req),
    {ok, Req1, State}.

terminate(_Reason, _Req, _State) ->
    ok.
