create table customers
(
    customercode serial
        primary key,
    firstname    varchar(50),
    lastname     varchar(50),
    timestamp    timestamp
);

alter table customers
    owner to postgres;

