create table uom
(
    uomid       serial
        primary key,
    description varchar(50)
);

alter table uom
    owner to postgres;

