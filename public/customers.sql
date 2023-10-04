create table customers
(
    customercode serial
        primary key,
    firstname    varchar(255),
    lastname     varchar(255),
    timestamp    timestamp
);

alter table customers
    owner to postgres;

