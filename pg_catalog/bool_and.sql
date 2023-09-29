create aggregate pg_catalog.bool_and(boolean) (
    sfunc = booland_statefunc,
    stype = boolean,
    combinefunc = booland_statefunc,
    parallel = safe,
    msfunc = bool_accum,
    minvfunc = bool_accum_inv,
    mstype = internal,
    msspace = 16,
    mfinalfunc = bool_alltrue,
    sortop = operator (<)
    );

comment on aggregate pg_catalog.bool_and(boolean) is 'boolean-and aggregate';

alter aggregate pg_catalog.bool_and(boolean) owner to postgres;

