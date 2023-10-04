create table uom
(
    uomid       serial
        primary key,
    description varchar(255)
);

alter table uom
    owner to postgres;

