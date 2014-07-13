
PROJECT = clustergps
ERLC_OPTS= "+{parse_transform, lager_transform}"

DEPS = cowboy lager
dep_cowboy = pkg://cowboy 0.10.0
dep_lager = https://github.com/basho/lager.git 2.0.3

-include erlang.mk

erlang.mk:
	@wget https://raw.githubusercontent.com/extend/erlang.mk/master/erlang.mk

deepclean:
	@rm -f deps
